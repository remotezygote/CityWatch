class DiskUsage
	
	include Watchman
	
	set_default :usage_threshold, 75
	
	def self.data
		dat = DF.data
		sum = dat.select {|d| d[:mounted]=="/"}.first
		{:partitions => dat, :summary => sum[:capacity] || sum["use%".to_sym]}
	end
	
	add_rule(:root_usage_high) do |data|
		
		if (usage = data[:summary].to_i) && usage > option(:usage_threshold)
			send_alert "Root disk usage is over #{option(:usage_threshold)}% (#{usage}%)", data[:partitions].select {|d| d[:mounted]=="/"}.first
			set_flag :root_disk_over_quota
		else
			clear_flag :root_disk_over_quota
		end
		
	end
	
	dataset(:save_dataset) do |data|
		add_to_data_set(:root_disk_usage,data[:summary].to_f)
	end
	
end