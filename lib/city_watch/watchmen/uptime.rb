class Uptime
	
	include Watchman
	
	set_default :uptime_file, '/proc/uptime'
	
	def self.data
		return {} if !File.exists?(option(:uptime_file))
		out = {}
		out[:uptime], out[:idle] = File.read(option(:uptime_file)).strip.split.map {|t| Float(t) }
		base = out.dup
		[[:minutes,Proc.new{|t| t / 60 }],[:hours,Proc.new{|t| t / (60*60) }],[:days,Proc.new{|t| t / (60*60*24) }]].each do |(id,func)|
			base.each do |k,v|
				out["#{k.to_s}_#{id.to_s}".to_sym] = func.call(v).round(2)
			end
		end
		out.merge({:summary => [:uptime_days]})
	end
	
end