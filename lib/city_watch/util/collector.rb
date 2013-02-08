module Collector
	
	def self.send!(addr,dat)
		require "yajl"
		require 'net/http'
		require 'net/https'
		puts "Sending message to: http#{CityWatch.config[:secure] ? "s" : ""}://#{addr}/receive" if CityWatch.debug?
		uri = URI.parse("http#{CityWatch.config[:secure] ? "s" : ""}://#{addr}/receive")
		http = Net::HTTP.new(uri.host, uri.port)
		if CityWatch.config[:secure]
			http.use_ssl = true
			http.ssl_version = :SSLv3
			http.verify_mode = OpenSSL::SSL::VERIFY_PEER
			if File.exists?('/etc/ssl/certs') # Ubuntu
				http.ca_path = '/etc/ssl/certs'
			end
		end
		req = Net::HTTP::Post.new(uri.path)
		req.body = Yajl::Encoder.encode(dat)
		req["Content-Type"] = 'application/json'
		case http.request(req)
			when Net::HTTPSuccess
				puts "Successfully sent to collector." if CityWatch.debug?
			else
				raise Exception
		end
	end
	
end