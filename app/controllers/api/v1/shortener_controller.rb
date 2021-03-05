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
    body = request.body.read
    if body.blank?
      uri = params.try(:[], "uri")
    else
      uri = JSON.parse(body).try(:[], "uri")
    end
    # Validate the format
    protocol, prefix, host, domain = [nil, nil, nil, nil]
    if shortener.valid_url?(uri)
      @valid = true
      shortener.set_protocol_and_host(uri) do |matchData|
        protocol, prefix, host, domain = matchData.captures
      end
      short_url = shortener.create_short_url(protocol: protocol, host: host, domain: domain)
      $redis.hset("shortened_urls", short_url, uri)
    end
    respond_to do |format|
      format.json do
        if @valid
          render json: { short: short_url, original: uri }, status: 201
        else
          render json: { success: false, error: shortener::MalformedUrl }, status: 422
        end
      end
      format.js {}
      format.html do
        redirect_to Rails.application.routes.url_helpers.shortened_urls_path, success: "Your url was shortened successfully!"
      end
    end
   end

 private
 def shortener
    ::UrlShortener
 end
end
