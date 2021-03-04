require_relative '../../../../lib/modules/shortener'

class Api::V1::ShortenerController < ApplicationController
  include ActionController::MimeResponds

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
    end
    respond_to do |format|
      format.json do
        if @valid
          render json: { short: uri, original: uri }, status: 201
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