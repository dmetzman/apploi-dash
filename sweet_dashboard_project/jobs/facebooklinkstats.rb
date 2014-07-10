#!/usr/bin/env ruby
require 'net/http'
require 'json'
 
# The url you are tracking
sharedlink = URI::encode('www.apploi.com')
 
SCHEDULER.every '1m' do
  fbstat = []
 
  http = Net::HTTP.new(graph.facebook.com)
  puts Net::HTTP::Get.new("/fql?q=SELECT%20share_count,%20like_count,%20comment_count,%20total_count%20FROM%20link_stat%20WHERE%20url%3D%22#{sharedlink}%22")
  response = http.request(Net::HTTP::Get.new("/fql?q=SELECT%20share_count,%20like_count,%20comment_count,%20total_count%20FROM%20link_stat%20WHERE%20url%3D%22#{sharedlink}%22"))
  puts response.body
  fbcounts = JSON.parse(response.body)['data']
 
  fbcounts[0].each do |stat|
    fbstat << {:label=>stat[0], :value=>stat[1]}
  end
 
   send_event('fblinkstat', { items: fbstat })

 
end