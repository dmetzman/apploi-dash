require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'foZqbODg3XKk4wVYtaiw1g1tU'
  config.consumer_secret = 'RxWI0VwLy7urE7p7sXqtwePuVfGRUhUyg8R44qfdLTAnnS6K1z'
  config.access_token = '2601007958-JDcmoQmWpUHiyexoqCVroBMLW9ADpfFgNVPHdES'
  config.access_token_secret = 'mKbLtVmjhA7sq560BHjBO5M48E098xJ0WmhYMgy6F4dRm'
end

search_term = URI::encode('#apploi')

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
