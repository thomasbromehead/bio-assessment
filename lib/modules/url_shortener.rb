module UrlShortener

  CorrectFormat = %r(^(https?:\/\/)?(w{3})?\.?([a-z]+)\.([a-z]{3}|[a-z]{2}\.[a-z]{2})$)
  MalformedUrl = "You submitted a malformed URL".freeze

  def self.valid_url?(url)
     !!url.match(CorrectFormat)
  end

  def self.set_protocol_and_host(url)
    yield url.match(CorrectFormat)
  end

  def self.create_short_url(protocol:, host:, domain:)
    encoded = Base64.urlsafe_encode64("#{host}#{domain}", padding:false)[0..2]
    url = ShortUrl.new(protocol, encoded, domain)
    class << url
      def to_s
        "#{protocol}#{host}.#{domain}"
      end
    end
    url.to_s
  end

  private
  ShortUrl = Struct.new(:protocol, :host, :domain)
end

