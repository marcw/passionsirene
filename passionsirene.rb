require 'twitter'

Twitter.configure do |config|
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.oauth_token        = ENV['ACCESS_TOKEN']
    config.oauth_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

r = Random.new

original = "A" * r.rand(1..15)
original += "H" * r.rand(4..15)
original += "U" * r.rand(10..35)

Twitter.update(original)
