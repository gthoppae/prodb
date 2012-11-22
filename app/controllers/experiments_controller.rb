class ExperimentsController < ApplicationController
	layout "application", :except => [:list_filtered]
	helper 'samples'

  def index
		@body_id = "tab2"
    list
    render :action => 'list'
  end

  def search
		#@phrase = request.raw_post || request.query_string
		#matcher = Regex.new( @phrase )
  	#@exps = Project.find_by_name(@phrase)
		render 'export'
  end

  def export
		filename = "experiments-" + Time.now.strftime('%Y%m%d') + ".xls"
  	headers["Content-Type"] = "application/vnd.ms-excel"
  	headers["Content-Disposition"] = "attachment; filename=#{filename}"
		headers['Cache-Control'] = ''
  	@exps = Experiment.find :all
		#send_data( render_to_string('experiments'), :filename=> '/tmp/results.csv' )
		render :layout => false
  end

  def list_filtered
		#keyword = '"' + "name LIKE '%" + params['keyword'] + "%'" + '"'
		#logger.debug( "keyword: #{keyword}" )
		if params[:keyword] == "" or params[:field] == ""
    	list	
			@only_table = true
			render :action => 'list', :layout => false
		else
			if params[:field] == "project"
				@projects = Project.paginate :page => params[:page], :conditions =>[ "(name LIKE ?)", "%#{params['keyword']}%"], :order => "created_on DESC", :per_page => 50
				if (@projects.size == 0)
					render :text => "No projects found with the keyword " + params[:keyword]
				else
					render #_list_filtered
				end
			else
				@experiments = Experiment.paginate :page => params[:page], :conditions =>[ "(hypothesis LIKE ? OR annotation LIKE ?)", "%#{params['keyword']}%", "%#{params['keyword']}%"], :order => "created_on DESC", :per_page => 50
				
				render :partial => "list_experiments", :locals => { :experiments => @experiments, :keyword => params[:keyword] }, :layout => false
			end
			#render :text => params.inspect, :layout => false
		end
  end

	def by_date
		@experiments = Experiment.find( :all, :conditions => ["year(created_on) >= ? AND month(created_on) >= ?", params[:year], params[:month] ] )
		#render :text => @experiments.inspect
		@paginate = false
		render :action => 'list'
	end

  def list
		if not params.include?(:page)
			params[:page] = 1
		end
		@experiments = Experiment.paginate :page => params[:page], :order => "created_on DESC", :per_page =>20
  end


  def show
		respond_to do |format|
    	@experiment = Experiment.find(params[:id], :order => "created_on DESC" )
			format.html {
				session[:prev_loc] = request.request_uri
				@background = "#eee";
			}
			format.xml  { render :file => 'experiments/show.rxml', :layout => false, :use_full_path => true }
		end
  end

  def new
    @experiment = Experiment.new
  end

  def create
    @experiment = Experiment.new(params[:experiment])
    if @experiment.save
      flash['notice'] = 'Experiment was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @experiment = Experiment.find(params[:id])
  end

  def update
    @experiment = Experiment.find(params[:id])
    if @experiment.update_attributes(params[:experiment])
      flash['notice'] = 'Experiment was successfully updated.'
      redirect_to :action => 'show', :id => @experiment
    else
      render_action 'edit'
    end
  end

  def destroy
    e = Experiment.find(params[:id])
		#e.deleted = 'y'
		#e.save
		e.destroy
    redirect_to :action => 'list'
  end

  #def add_sample
	#	@exp = Experiment.find(params[:id])
	#	@sample = Sample.new
	##	@exp.samples << @sample
	#	@exp.save
	#end


  def import_samples

    @experiment = Experiment.find(params[:id])
    #@experiment = Experiment.find(params[:id], :include => :project)
    if request.post?
      render :text => params['samples']['samples'].split("\n")[0].chomp.split("\t").inspect
    else
      # do something
    end

  end

end
