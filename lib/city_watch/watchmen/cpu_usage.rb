class CPUUsage
	
	include Watchman
	
	def self.data
		out = MPstat.data.select do |line|
			line[:command][/^Average:/]
		end
		out.length > 0 ? out.first.merge({:summary => [:usr, :idle, :sys]}) : {:nodata => true}
	end
	
end