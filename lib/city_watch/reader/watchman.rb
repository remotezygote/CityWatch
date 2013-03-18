module Reader
	
	class Watchman
		
		include Renderer
		
		def initialize(host,name)
			@host = host
			@name = name
		end
		
		def render_from_summary(data)
			@current_data = data
			return render("watchmen/#{@name}/summary", "watchmen/summary")
			ensure
			@current_data = nil
		end
		
		def watchman_class
			@klass ||= Object.const_get(@name.to_sym)
		end
		
		def sparklines
			data_sets.map do |set|
				[set.to_sym,sparkline(get_data_set(set).map {|(tm,val)| val })]
			end
		end
		
		def sparkline_image_tags
			data_sets.map do |set|
				[set.to_sym, sparkline_img_tag(get_data_set(set).map {|(tm,val)| val })]
			end
		end
		
		def get_data_set(data_set_name,s_time=(Time.now - (60*60*12)),e_time=Time.now)
			CityWatch.redis.zrevrangebyscore(data_set_key(data_set_name), s_time.to_i, e_time.to_i, :with_scores => true).map do |(val,score)|
				timestamp,value = val.split(",")
				[Time.at(timestamp.to_i), value]
			end
		end
		
		def data_set_key(data_set)
			key("data_set::#{data_set}")
		end
		
		def data_sets
			CityWatch.redis.smembers(data_sets_key)
		end
	
		def data_sets_key
			@data_sets_key ||= key(:data_sets)
		end
		
		def sparkline(dat)
			Base64.encode64(Spark.smooth(dat, :has_min => true, :has_max => true, :height => 14, :step => 4)).gsub("\n",'')
		end

		def sparkline_img_tag(dat)
			"<img src=\"data:image/png;base64,#{sparkline(dat)}\"/>"
		end
		
		def key(more)
			"#{key_prefix}::#{more}"
		end
		
		def key_prefix
			@key_prefix ||= "#{CityWatch.config[:prefix]}::#{@host}::#{@name}"
		end
		
	end
	
end