module Reader
	
	class Watchman
		
		include Renderer
		
		def initialize(host,name)
			@host = host
			@name = name
		end
		
		def render_from_summary(data)
			@current_data = data
			render_bare "watchmen/#{@name}/summary", "watchmen/summary"
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
				dat = get_data_set(set)
				puts dat.inspect
				[set.to_sym, dat.length > 1 ? sparkline_img_tag(dat.map {|(tm,val)| val }, "#{set}") : nil]
			end.select {|(name,tag)| !tag.nil? }
		end
		
		def get_data_set(data_set_name,s_time=(Time.now - (60*60*4)),e_time=Time.now)
			CityWatch.redis.zrevrangebyscore(data_set_key(data_set_name), e_time.to_i, s_time.to_i, :with_scores => true).map do |(val,score)|
				timestamp,value = val.split(",")
				[Time.at(timestamp.to_i), Float(value).to_i]
			end.reverse
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
			require 'base64'
			require 'city_watch/util/spark_pr'
			Base64.encode64(Spark.smooth(dat, :height => 14, :step => 4).to_png).gsub("\n",'')
		end

		def sparkline_img_tag(dat,alt="")
			"<img src=\"data:image/png;base64,#{sparkline(dat)}\" alt=\"#{alt}\" title=\"#{alt} max: #{dat.max} min: #{dat.min}\"/>"
		end
		
		def sparkline_for(set)
			dat = get_data_set(set)
			if dat.length > 1
				puts dat.inspect
				require 'base64'
				require 'city_watch/util/spark_pr'
				Base64.encode64(Spark.smooth(dat.map {|(tm,val)| val }, :height => 14, :step => 4).to_png).gsub("\n",'')
			end
		end

		def sparkline_img_tag_for(set)
			dat = get_data_set(set)
			if dat.length > 1
				sparkline_img_tag(dat.map {|(tm,val)| val },set)
			else
				""
			end
		end
		
		def key(more)
			"#{key_prefix}::#{more}"
		end
		
		def key_prefix
			@key_prefix ||= "#{CityWatch.config[:prefix]}::#{@host}::#{@name}"
		end
		
	end
	
end