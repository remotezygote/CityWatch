module Watchman
	
	def data
		{}
	end
	
	module ClassMethods
		
	end
	
	def self.included(base)
		base.extend(ClassMethods)
		Watchmen.register(base)
	end
	
end