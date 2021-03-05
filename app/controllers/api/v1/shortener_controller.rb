require_relative '../../../../lib/modules/url_shortener'

class Api::V1::ShortenerController < ApplicationController
  include ActionController::MimeResponds

  def index
    @urls = $redis.hgetall("shortened_urls")
  end

  def show
    short_url = params["url"]
    if short_url
      # get the corresponding full url
      full_url = $redis.hget("shortened_urls", short_url)
      redirect_to full_url, status: :moved_permanently
    end
  end

  def shorten
    json_call = request.headers["Content-Type"] == "application/json"
    if json_call
      body = request.body.read rescue ""
      uri = JSON.parse(body).try(:[], "uri")
    else
      uri = params.try(:[], "uri")
    end
    short_url = do_shorten(uri)
        if @valid
          url_html = render_to_string("shared/_url", locals: {url: [short_url, uri]}, layout: false)
          render json: { success: true, short: short_url, original: uri, content: url_html  }, status: 201
        else
          binding.irb
          render json: { success: false, error: shortener::MalformedUrl }, status: 422
        end
     # format.html do
     #   redirect_to Rails.application.routes.url_helpers.shortened_urls_path, success: "Your url was shortened successfully!"
     # end
     # format.js {}
   end

 private
 def shortener
    ::UrlShortener
 end

 def do_shorten(uri)
  protocol, prefix, host, domain = [nil, nil, nil, nil]
  binding.irb
  if shortener.valid_url?(uri)
    binding.irb
    @valid = true
    shortener.set_protocol_and_host(uri) do |matchData|
      protocol, prefix, host, domain = matchData.captures
    end
    short_url = shortener.create_short_url(protocol: protocol, host: host, domain: domain)
    $redis.hset("shortened_urls", short_url, uri)
    return short_url
  end
  false
 end
end
