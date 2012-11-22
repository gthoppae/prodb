class ProjectsController < ApplicationController

	layout 'application'

	def create_ajax
		@project = Project.new(params["project"])
		if @project.save
			render_partial 'project', @project
		end
	end

  def index
		redirect_to :controller => 'projects', :action => 'list'
  end

  def list

		if not params.include? :page
			params[:page] = 1
		end
    @projects = Project.paginate :page => params[:page], :order => "created_on DESC", :per_page => 20
  end

	def list_as_icons
    @projects = Project.paginate :page => params[:page], :order_by => "created_on DESC", :per_page => 20
    #@project_pages, @projects = paginate :project, :order_by => "created_on DESC", :per_page => 20
	end

  def show
		@background = ""
    @project = Project.find(params[:id], :include => :experiments )
		#logger.info("Project: " + @project.experiments.inspect )
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash['notice'] = 'Project was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash['notice'] = 'Project was successfully updated.'
      redirect_to :action => 'list'
    else
      render_action 'edit'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
