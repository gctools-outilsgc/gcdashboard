require 'twitter'
require 'yaml'
require_relative '../config.rb'

twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = TW_KEY
  config.consumer_secret = TW_SECRET
  config.access_token = TW_TOKEN
  config.access_token_secret = TW_TOKEN_SECRET
end

search_term = URI::encode('#gctools')
SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end

# GCtools twitter feed
gctools_search_term = URI::encode('#gctools')
outilsgc_search_term = URI::encode('#outilsgc')
SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{gctools_search_term}+OR+#{outilsgc_search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions_gctools', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end

# GC2020 twitter feed
gc2020_search_term = URI::encode('#gc2020')
SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{gc2020_search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions_gc2020', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end

# GoC twitter feed
#
# goc_search_term = URI::encode('#GoC')
# SCHEDULER.every '10m', :first_in => 0 do |job|
#   begin
#     tweets = twitter.search("#{goc_search_term}")
# 
#     if tweets
#       tweets = tweets.map do |tweet|
#         { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
#       end
#       send_event('twitter_mentions_goc', comments: tweets)
#     end
#   rescue Twitter::Error
#     puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
#   end
# end