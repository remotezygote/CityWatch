class Uptime
	
	include Watchman
	
	def self.data
		out = {}
		out[:uptime], out[:idle] = File.read('/proc/uptime').strip.split.map {|t| Float(t) }
		base = out.dup
		[[:minutes,Proc.new{|t| t / 60 }],[:hours,Proc.new{|t| t / (60*60) }],[:days,Proc.new{|t| t / (60*60*24) }]].each do |(id,func)|
			base.each do |k,v|
				out["#{k.to_s}_#{id.to_s}".to_sym] = func.call(v).round(2)
			end
		end
		out.merge({:summary => [:uptime_days]})
	end
	
end