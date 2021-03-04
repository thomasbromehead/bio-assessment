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

  def self.flush_all
    puts "deleting keys"
    previous_number_of_keys = self.find_keys.size
    puts "Previous number of keys: #{previous_number_of_keys}"
    return if previous_number_of_keys.zero?
    puts "Found #{previous_number_of_keys} keys to delete"
    @redis.flushall
    new_number_of_keys = find_keys.size
    if new_number_of_keys.zero?
      puts "Flushed everything"
    else
      puts "Failed deleting some keys, there are still: #{new_number_of_keys} keys."
    end
  end

  def self.hset(k, *attrs)
    @redis.hset(k, *attrs)
  end

  def self.zadd(key, *args)
    @redis.zadd(key, *args)
  end

  # If no pattern will be called with * by default by redis
  def self.find_keys(pattern="*")
    results = @redis.keys(pattern)
    if block_given?
      transformed = yield results
      return transformed
    end
    results
  end

  def self.is_sorted_set_member(key, member)
    @redis.zscore(key, member)
  end

  def self.zrangebyscore(**kwargs)
    key, min, max, limit = kwargs[:key], kwargs[:min], kwargs[:max], kwargs[:limit]
    results = @redis.zrangebyscore(key, min, max, limit: limit)
    yield results
  end

  def self.del(*k)
    @redis.del(*k)
  end

  def self.zrem(set, value)
    @redis.zrem(set, value)
  end

  def self.hget(k, *args)
    @redis.hget(k, *args)
  end

  def self.hkeys(k)
    yield @redis.hkeys(k)
  end

  def self.hgetall(k)
    results = @redis.hgetall(k)
    yield results
  end

  def self.hscan(key, cursor, **options)
    results = @redis.hscan(key, cursor, **options)
    yield results if block_given?
    results
  end

  def self.zcard(key)
    @redis.zcard(key)
  end


  def self.hscan_each(key, **options)
    results = @redis.hscan_each(key, **options)
    yield results if block_given?
    results
  end

  def self.multi(&block)
    puts "inside redis multi"
    @redis.multi { block.call() }
  end

  def self.get_sorted_set_members(key, pattern, &block)
    results = @redis.zscan_each(key, match: pattern)
    if block
      exact_match = block.call(results)
      return exact_match
    else
      return results
    end
  end

  def self.get_sorted_set_member(key, pattern)
    results = @redis.scan(key, match: pattern)
    yield results
  end
end
