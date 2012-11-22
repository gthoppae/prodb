class Project < ActiveRecord::Base
	has_many :experiments, :dependent => :destroy

	def human_created_on 
		if not attributes["created_on"].nil?
			attributes["created_on"].strftime( "%d %B, %Y %H:%M hrs" )
		end
	end
	
end
