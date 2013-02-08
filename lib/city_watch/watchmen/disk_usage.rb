class DiskUsage
	
	include Watchman
	
	def self.data
		{:partitions => DF.data}
	end
	
end