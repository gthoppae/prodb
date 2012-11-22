class OrganismsController < ApplicationController
	layout 'application'

  def index
    list
    render :action => 'list'
  end

  def list
		if not params.include? :page
      params[:page] = 1
    end
    @organisms = Organism.paginate :page => params[:page], :per_page => 20
		@paginate = true
  end

  def show
    @organism = Organism.find(params[:id])
  end

  def new
    @organism = Organism.new
  end

  def create
    @organism = Organism.new(params[:organism])
    if @organism.save
      flash[:notice] = 'Organism was successfully created.'
      redirect_to :action => 'list'
    else
      flash[:error] = 'Organism was not created. ' + @organism.errors.inspect
      #render :text => @organism.errors.inspect
      render :action => 'new'
    end
  end

  def edit
    @organism = Organism.find(params[:id])
  end

  def update
    @organism = Organism.find(params[:id])
    if @organism.update_attributes(params[:organism])
      flash['notice'] = 'Organism was successfully updated.'
      redirect_to :action => 'show', :id => @organism
    else
      render :action => 'edit'
    end
  end

  def destroy
    Organism.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
