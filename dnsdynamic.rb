#!/usr/bin/env ruby
require 'net/http'
require 'net/https'

#example -> ruby dnsdynamic.rb username password domain timeout

username = ARGV[0]
password = ARGV[1]
domain = ARGV[2]
timeout = ARGV[3]

def change(username, password, domain, currentIP)
	http = Net::HTTP.new('dnsdynamic.org',443)
	req = Net::HTTP::Get.new('https://www.dnsdynamic.org/api/?hostname='+domain+'.dnsdynamic.com&myip='+currentIP)
	http.use_ssl = true
	req.basic_auth username, password
	response = http.request(req)
	time1 = Time.new
	File.open("ddns.log", 'a') {|f| f.write(time1.inspect+': '+response.body) }
end

def getCurrentIP()
	currentIP=""
	http1 = Net::HTTP.new('myip.dnsdynamic.org',80)
	req1 = Net::HTTP::Get.new('http://myip.dnsdynamic.org')
	http1.use_ssl = false
	response1 = http1.request(req1){|response|
	  response.read_body do |str|
	    currentIP = str
	  end
	}
	return currentIP
end

while 1 do
	change(username,password,domain,getCurrentIP())
	sleep(60* Integer(timeout))
end
