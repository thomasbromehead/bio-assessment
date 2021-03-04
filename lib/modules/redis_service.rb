require 'redis'

module RedisService

  def self.start(host,port)
    @redis ||= Redis.new(host: host, port: port)
    self
  end

  def self.hset(k, *attrs)
    @redis.hset(k, *attrs)
  end

  def self.get(k)
    @redis.get(k)
  end

  def self.hget(k, *args)
    @redis.hget(k, *args)
  end

  def self.hgetall(k)
    results = @redis.hgetall(k)
    yield results if block_given?
    results
  end
end
