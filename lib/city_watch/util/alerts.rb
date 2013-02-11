module Alerts
	
	def send_alert(message,dat=nil)
		CityWatch.redis.zadd "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::alerts", rcv_time, Yajl::Encoder.encode({:message => message, :data => dat, :when => rcv_time})
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
		CityWatch.redis.zrevrange "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::alerts", 0, num - 1
	end

	def send_alerts!
		get_alerts.map do |alert|
			puts "Alert: #{alert.inspect}" if CityWatch.debug?
		end
	end
	
end