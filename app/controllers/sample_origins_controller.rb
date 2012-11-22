class SampleOriginsController < ApplicationController
	layout 'application'
  def index
    list
    render :action => 'list'
  end

  def list
		if not params.include? :page
      params[:page] = 1
    end
    @sample_origins = SampleOrigin.paginate :page => params[:page], :per_page => 20
		@paginate = true
  end

  def show
    @sample_origin = SampleOrigin.find(params[:id])
  end

  def new
    @sample_origin = SampleOrigin.new
  end

  def create
    @sample_origin = SampleOrigin.new(params[:sample_origin])
    if @sample_origin.save
      flash[:notice] = 'SampleOrigin was successfully created.'
      redirect_to :action => 'list'
    else
      flash[:error] = 'SampleOrigin was not created. ' +  @sample_origin.errors.inspect
      render :action => 'new'
    end
  end

  def edit
    @sample_origin = SampleOrigin.find(params[:id])
  end

  def update
    @sample_origin = SampleOrigin.find(params[:id])
    if @sample_origin.update_attributes(params[:sample_origin])
      flash[:notice] = 'SampleOrigin was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    SampleOrigin.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
