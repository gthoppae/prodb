class DashboardController < ApplicationController
  helper :sparklines
	caches_action :index

  def index
    @d = Dashboard.new
    @largest_experiment = @d.largest_experiment
  end

  def activity
		g = Gruff::Line.new(200)
		g.title = "Activity"
		Sample.each do |s|
			s.created_on
		end
  end
end

