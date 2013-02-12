module DataSets
	
	def dataset(name,&block)
		@datasets ||= {}
		@datasets[name] = block
	end
	
	def run_dataset_collector(dat)
		@datasets.map do |(name,dataset)|
			dataset.call(dat)
		end if @datasets
	end
	
	def get_data_set(data_set_name,s_time,e_time=Time.now,host=host)
		CityWatch.redis.zrevrangebyscore(data_set_key(data_set_name,host), s_time.to_i, e_time.to_i, :with_scores => true).map do |(val,score)|
			timestamp,value = val.split(",")
			[Time.at(timestamp.to_i),value]
		end
	end
	
	def data_set_key(data_set_name,host=host)
		"#{CityWatch.config[:prefix]}::#{host}::#{self.name}::data_set::#{data_set_name}"
	end
	
	def add_to_data_set(data_set_name,val,time=Time.now,host=host)
		CityWatch.redis.zadd data_set_key(data_set_name,host), time.to_i, "#{Time.now.to_i},#{val}"
	end
	
end