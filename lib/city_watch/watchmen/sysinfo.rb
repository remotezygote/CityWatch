class SystemInfo
	
	include Watchman
	
	require 'sysinfo'
	
	def self.data
		SysInfo.new.to_hash
	end
	
end