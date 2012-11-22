class PeopleController < ApplicationController
	layout "application"

	def index
		list
		render :action => 'list'
	end

	def list
		if params[:starts_with]
			#@people = Person.find( :all, :conditions => [ "first_name like '?'", params[:start_with] ] )
			@people = Person.paginate :page => params[:page], :conditions => [ "last_name like  ?", params[:starts_with]+'%' ], :per_page => 20 
		else
			#@person_pages, @people = paginate :people, :order => "last_name", :per_page => 20
			@people = Person.paginate :page => params[:page], :order => "last_name", :per_page => 20
		end
	end

	def new 
		@person = Person.new
	end

	def edit
		@person = Person.find( params[:id] )
	end

	def create
		@person = Person.new( params[:person] )
		if @person.save
			flash[:notice] = "Contact successfully saved"
			
			redirect_to :action => "list"
		else
			flash[:error] = "Problem while saving the contact!"
			render :action => "new"
		end
	end

	def update
		@person = Person.find( params[:id] )
		if @person.update_attributes( params[:person] )
			flash[:notice] = "Contact successfully updated"
			redirect_to :action => "list"
		else
			flash[:error] = "Problem while updating the contact!"
			render :action => "new"
		end
	end

	def destroy
		Person.find( params[:id] ).destroy
		list
		render :action => 'list'
	end

end
