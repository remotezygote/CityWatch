class DiskUsage
	
	include Watchman
	
	def self.data
		dat = DF.data
		sum = dat.select {|d| d[:mounted]=="/"}.first
		{:partitions => dat, :summary => sum[:capacity] || sum["use%".to_sym]}
	end
	
end