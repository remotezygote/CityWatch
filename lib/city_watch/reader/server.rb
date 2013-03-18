module Reader
	
	def self.servers
		CityWatch.redis.smembers("#{CityWatch.config[:prefix]}::known_hosts").map do |server|
			Reader::Host.new(server)
		end
	end
	
	class Host
		
		include Renderer
	
		def initialize(host)
			@host = host
		end
		
		def hostname
			@host
		end
		
		def watchmen
			CityWatch.redis.smembers(watchmen_key).map do |name|
				Reader::Watchman.new(name)
			end
		end
		
		def watchmen_key
			key(:watchmen)
		end
	
		def data_sets
			CityWatch.redis.smembers(data_sets_key)
		end
	
		def data_sets_key
			@data_sets_key ||= key(:data_sets)
		end
		
		def summary
			summaries.first
		end
		
		def summary_html
			render_bare "server/summary"
		end
		
		def summaries(num=1)
			CityWatch.redis.zrevrange(summary_key,0,num).map {|sum| Yajl::Parser.parse(sum) }
		end
		
		def summary_key
			@summary_key ||= key(:summary)
		end
		
		def current_raw
			raws.first
		end
		
		def raws(num=1)
			CityWatch.redis.zrevrange(raw_key,0,num)
		end
		
		def raw_key
			@raw_key ||= key(:raw_stats)
		end
		
		def key(more)
			"#{key_prefix}::#{more}"
		end
		
		def key_prefix
			@key_prefix ||= "#{CityWatch.config[:prefix]}::#{@host}"
		end
		
	end
	
end

# CityWatch::earlgray.cozy.co::raw_stats
# CityWatch::earlgray.cozy.co::summary

# CityWatch::earlgray.cozy.co::DiskUsage
# CityWatch::earlgray.cozy.co::DiskUsage::summary
# CityWatch::earlgray.cozy.co::DiskUsage::data_set::root_disk_usage
# CityWatch::earlgray.cozy.co::DiskUsage::data_sets

# CityWatch::earlgray.cozy.co::Uptime
# CityWatch::earlgray.cozy.co::Uptime::summary
# CityWatch::earlgray.cozy.co::Uptime::status

# CityWatch::earlgray.cozy.co::SystemInfo
# CityWatch::earlgray.cozy.co::SystemInfo::summary

# CityWatch::earlgray.cozy.co::Nginx
# CityWatch::earlgray.cozy.co::Nginx::summary

# CityWatch::earlgray.cozy.co::CPUUsage
# CityWatch::earlgray.cozy.co::CPUUsage::summary

# CityWatch::earlgray.cozy.co::Unicorns
# CityWatch::earlgray.cozy.co::Unicorns::summary






# CityWatch::rooibos.cozy.co::raw_stats
# CityWatch::jasmine.cozy.co::CPUUsage::summary
# CityWatch::sencha.cozy.co::raw_stats
# CityWatch::pekoe.cozy.co::DiskUsage
# CityWatch::sencha.cozy.co::SystemInfo::summary
# CityWatch::sencha.cozy.co::Unicorns::summary
# CityWatch::rooibos.cozy.co::DiskUsage::flags
# CityWatch::pekoe.cozy.co::Uptime
# CityWatch::pekoe.cozy.co::DiskUsage::summary
# CityWatch::jasmine.cozy.co::CPUUsage
# CityWatch::pekoe.cozy.co::Uptime::summary
# CityWatch::pekoe.cozy.co::Nginx::summary
# CityWatch::sencha.cozy.co::Uptime::summary
# CityWatch::oolong.cozy.co::CPUUsage::summary
# CityWatch::oolong.cozy.co::Nginx::summary
# CityWatch::oolong.cozy.co::Uptime
# CityWatch::oolong.cozy.co::SystemInfo
# CityWatch::sencha.cozy.co::Uptime
# CityWatch::pekoe.cozy.co::DiskUsage::data_sets
# CityWatch::rooibos.cozy.co::DiskUsage
# CityWatch::pekoe.cozy.co::raw_stats
# CityWatch::rooibos.cozy.co::Uptime::status
# CityWatch::sencha.cozy.co::SystemInfo
# CityWatch::rooibos.cozy.co::Nginx::summary
# CityWatch::pekoe.cozy.co::CPUUsage
# CityWatch::sencha.cozy.co::CPUUsage
# CityWatch::rooibos.cozy.co::Unicorns
# CityWatch::sencha.cozy.co::DiskUsage::summary
# CityWatch::pekoe.cozy.co::CPUUsage::summary
# CityWatch::jasmine.cozy.co::DiskUsage::data_sets
# CityWatch::oolong.cozy.co::CPUUsage
# CityWatch::rooibos.cozy.co::SystemInfo::summary
# CityWatch::pekoe.cozy.co::Unicorns::summary
# CityWatch::pekoe.cozy.co::Nginx
# CityWatch::jasmine.cozy.co::Unicorns
# CityWatch::sencha.cozy.co::summary
# CityWatch::pekoe.cozy.co::Uptime::status
# CityWatch::pekoe.cozy.co::SystemInfo
# CityWatch::jasmine.cozy.co::Nginx
# CityWatch::rooibos.cozy.co::CPUUsage
# CityWatch::oolong.cozy.co::Uptime::status
# CityWatch::sencha.cozy.co::Nginx::summary
# CityWatch::pekoe.cozy.co::DiskUsage::data_set::root_disk_usage
# CityWatch::sencha.cozy.co::Unicorns
# CityWatch::known_hosts
# CityWatch::sencha.cozy.co::CPUUsage::summary
# CityWatch::jasmine.cozy.co::Uptime::summary
# CityWatch::rooibos.cozy.co::DiskUsage::data_sets
# CityWatch::jasmine.cozy.co::SystemInfo
# CityWatch::oolong.cozy.co::Nginx
# CityWatch::pekoe.cozy.co::Unicorns
# CityWatch::oolong.cozy.co::Uptime::summary
# CityWatch::sencha.cozy.co::DiskUsage
# CityWatch::oolong.cozy.co::SystemInfo::summary
# CityWatch::oolong.cozy.co::DiskUsage::data_set::root_disk_usage
# CityWatch::sencha.cozy.co::Nginx
# CityWatch::jasmine.cozy.co::Uptime
# CityWatch::rooibos.cozy.co::DiskUsage::summary
# CityWatch::DiskUsage::flag_map
# CityWatch::oolong.cozy.co::DiskUsage::data_sets
# CityWatch::rooibos.cozy.co::DiskUsage::alerts
# CityWatch::jasmine.cozy.co::Unicorns::summary
# CityWatch::sencha.cozy.co::DiskUsage::data_set::root_disk_usage
# CityWatch::jasmine.cozy.co::DiskUsage::summary
# CityWatch::sencha.cozy.co::Uptime::status
# CityWatch::oolong.cozy.co::summary
# CityWatch::jasmine.cozy.co::DiskUsage
# CityWatch::rooibos.cozy.co::summary
# CityWatch::rooibos.cozy.co::Unicorns::summary
# CityWatch::oolong.cozy.co::raw_stats
# CityWatch::rooibos.cozy.co::SystemInfo
# CityWatch::rooibos.cozy.co::Uptime
# CityWatch::rooibos.cozy.co::DiskUsage::data_set::root_disk_usage
# CityWatch::pekoe.cozy.co::SystemInfo::summary
# CityWatch::jasmine.cozy.co::SystemInfo::summary
# CityWatch::rooibos.cozy.co::Uptime::summary
# CityWatch::oolong.cozy.co::Unicorns::summary
# CityWatch::oolong.cozy.co::Unicorns
# CityWatch::jasmine.cozy.co::raw_stats
# CityWatch::jasmine.cozy.co::Nginx::summary
# CityWatch::rooibos.cozy.co::CPUUsage::summary
# CityWatch::rooibos.cozy.co::Nginx
# CityWatch::oolong.cozy.co::DiskUsage
# CityWatch::jasmine.cozy.co::DiskUsage::data_set::root_disk_usage
# CityWatch::pekoe.cozy.co::summary
# CityWatch::sencha.cozy.co::DiskUsage::data_sets
# CityWatch::jasmine.cozy.co::Uptime::status
# CityWatch::oolong.cozy.co::DiskUsage::summary
# CityWatch::jasmine.cozy.co::summary