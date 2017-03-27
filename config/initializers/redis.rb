$redis = Redis.new(url: ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"])
