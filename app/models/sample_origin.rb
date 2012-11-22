class SampleOrigin < ActiveRecord::Base
	has_many :samples
	belongs_to :organism
end

