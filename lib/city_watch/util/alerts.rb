require 'mail'
require 'socket'

module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Alerts
	
	def send_alert(message,dat=nil)
		CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::alerts", rcv_time, Yajl::Encoder.encode({:message => message, :data => dat, :when => rcv_time})
		if eml = CityWatch.config[:alert_by_email]
			mail = Mail.new {
				from "citywatch@#{Socket.gethostbyname(Socket.gethostname).first}"
				to eml
				subject "CityWatch: ALERT #{message}"
				body "Alert data: #{data.inspect}"
			}
			mail.delivery_method :sendmail
			mail.deliver!
		end
	end

	def alerts
		@alerts ||= []
		if block_given?
			@alerts.each do |a|
				yield a
			end
		else
			@alerts
		end
		nil
	end

	def get_alerts(host=host,num=5)
		CityWatch.redis.zrevrange("#{CityWatch.config[:prefix]}::#{host}::#{self.name}::alerts", 0, num - 1).map {|dat| Yajl::Parser.new(:symbolize_keys => true).parse(dat) }
	end

	def send_alerts!(*args)
		get_alerts.map do |alert|
			puts "Alert: #{alert.inspect}" if CityWatch.debug?
		end
	end
	
end