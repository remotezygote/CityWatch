class DiskUsage
	
	include Watchman
	
	def self.data
		dat = DF.data
		{:partitions => dat, :summary => dat.select {|d| d[:mounted]=="/"}.first[:capacity]}
	end
	
end