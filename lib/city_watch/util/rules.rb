module Rules
	
	def add_rule(name,&block)
		@rules ||= {}
		@rules[name] = block
	end
	
	def run_rules(dat,rcv=nil,host=nil)
		@rules.map do |(name,rule)|
			rule.call(dat)
		end if @rules
	end
	
end