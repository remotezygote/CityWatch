class Redis
	
	include Watchman
	
	def self.data
		if opts[:ports]
			dat = opts[:ports].map do |port|
				out = `redis-cli -p #{port} info`
				out.gsub(/^(#.*|$)$/,'').gsub(/(\r\n)+/,"\r\n").split("\r\n").map {|str| str.strip.split(":") }.inject({}) {|acc,(k,v)| acc[k.to_sym] = v; acc }
			end
		end
	end
	
end