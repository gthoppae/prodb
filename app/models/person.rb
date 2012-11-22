class Person < ActiveRecord::Base
	has_many :samples
	validates_presence_of :email
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :on => :create


end
