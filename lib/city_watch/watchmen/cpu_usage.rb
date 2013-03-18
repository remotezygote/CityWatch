class CPUUsage
	
	include Watchman
	
	set_default :usage_threshold, 60
	
	def self.data
		out = MPstat.data.select do |line|
			line[:run][/^Average:/]
		end
		out.length > 0 ? out.first.merge({:summary => [:usr, :idle, :sys]}) : {:nodata => true}
	end
	
	add_rule(:cpu_usage_high) do |data|
		
		if (usage = data[:usr].to_i) && usage > option(:usage_threshold)
			send_alert "CPU usage is over #{option(:usage_threshold)}% (#{usage}%)", data
			set_flag :cpu_usage_high
		else
			clear_flag :cpu_usage_high
		end
		
	end
	
	dataset(:save_dataset) do |data|
		add_to_data_set(:cpu_user,data[:usr].to_f)
		add_to_data_set(:cpu_idle,data[:idle].to_f)
		add_to_data_set(:cpu_system,data[:sys].to_f)
	end
	
end