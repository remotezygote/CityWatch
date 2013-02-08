class CPUUsage
	
	include Watchman
	
	def self.data
		out = MPstat.data.select do |line|
			line[:run][/^Average:/]
		end
		out.length > 0 ? out.first.merge({:summary => [:usr, :idle, :sys]}) : {:nodata => true}
	end
	
end