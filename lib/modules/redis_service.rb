require 'redis'

module RedisService

  def self.start(host,port)
    @redis ||= Redis.new(host: host, port: port)
    self
  end

  def self.set(k,v)
    @redis.set(k,v)
  end

  def self.get(k)
    @redis.get(k)
  end

  def self.hgetall(k)
    results = @redis.hgetall(k)
    yield results if block_given?
    results
  end
end
