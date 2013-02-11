module Notifications
	
	def notify(*args)
		@notifications ||= []
		@notifications << [*args]
	end
	
end