module Status
	
	def set_status_var(var,val,host=host)
		CityWatch.redis.hset "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::status", var, val
	end
	
	def status_vars(host=host)
		CityWatch.redis.hgetall "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::status"
	end
	
	def status_var(var,host=host)
		CityWatch.redis.hget "#{CityWatch.config[:prefix]}::#{host}::#{self.name}::status", var
	end
	
end