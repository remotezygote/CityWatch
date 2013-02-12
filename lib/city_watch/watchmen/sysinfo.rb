class SystemInfo
	
	include Watchman
	
	require 'sysinfo'
	
	def self.data
		SysInfo.new.to_hash.merge({:summary => ["ipaddress_internal"]})
	end
	
end