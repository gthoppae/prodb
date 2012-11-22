class SearchController < ApplicationController
	layout 'application'

	def index
	end

  def list_filtered
		#keyword = '"' + "name LIKE '%" + params['keyword'] + "%'" + '"'
		#logger.debug( "keyword: #{keyword}" )
		if params[:keyword] == "" or params[:field] == ""
    	list	
			@only_table = true
			render :action => 'list', :layout => false
			#render :text => 'ha', :layout => false
		else
			if params[:field] == "project"
				@project_pages, @projects = paginate :project, :conditions =>[ "(name LIKE ?)", "%#{params['keyword']}%"], :order_by => "created_on DESC"
				render #_list_filtered
			else
				@experiment_pages, @experiments = paginate :experiment, :conditions =>[ "(hypothesis LIKE ?)", "%#{params['keyword']}%"], :order_by => "created_on DESC"
				
				render :partial => "list_table", :locals => { :experiments => @experiments }, :layout => false
			end
			#render :text => params.inspect, :layout => false
		end
  end



end
