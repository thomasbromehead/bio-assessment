require 'rails_helper'
require 'json'

RSpec.describe 'Api::V1::Shortener', type: :request do
  # include Rack::Test::Methods
  ShortenedUri = Struct.new(:original_url, :shortened_url)
    def call_and_parse(uri:, headers: nil)
      post "/shorten", params: {"uri": "#{uri}" }.to_json, headers: headers if headers
      response_body = JSON.parse(@response.body)
      response_body
    end

    def check_keys(keys)
      expect(@response_body.keys).to contain_exactly(*keys)
    end

    def check_status(status)
      expect(@response).to have_http_status(status.to_sym)
    end

    let(:valid_uri){ "http://www.bionic.co.uk" }
    let(:valid_uri_no_proto){ "www.bionic.co.uk" }
    let(:valid_uri_no_proto_no_prefix){ "bionic.co.uk" }
    let(:shortener){ instance_double('UrlShortener') }

    context "JSON CALLS" do
      Headers = { "ACCEPT" => "application/json" }
      context "With a valid URL" do
        context "with a full url" do
          it "when called with JSON it shortens and returns a JSON payload and a 201" do
            @response_body = call_and_parse(uri: valid_uri, headers: Headers)
            check_keys(['short', 'original'])
            check_status(:created)
          end
        end

        context "with a url without protocol" do
          it "when called with JSON it shortens and returns a JSON payload and a 201" do
            @response_body =  call_and_parse(uri: valid_uri_no_proto, headers: Headers)
            check_keys(['short', 'original'])
            check_status(:created)
          end
        end

        context "with a url without protocol and prefix" do
          it "when called with JSON it shortens and returns a JSON payload and a 201" do
            @response_body = call_and_parse(uri: valid_uri_no_proto_no_prefix, headers: Headers)
            check_keys(['short', 'original'])
            check_status(:created)
          end
        end
      end

      context "With an invalid URL" do
        let(:malformed_uri){ "http.sads.com" }
        it "should warn that the URL is malformed" do
          @response_body = call_and_parse(uri: malformed_uri, headers: Headers)
          expect(@response_body["success"]).to eq(false)
        end

        it "should return a 422" do
           call_and_parse(uri: malformed_uri, headers: Headers)
           check_status(:unprocessable_entity)
        end
      end
    end
end


