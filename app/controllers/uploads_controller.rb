class UploadsController < ApplicationController
	layout "application"
	def index
		redirect_to :action => "list"
	end

	def new
		if request.get?
			@upload = Upload.new
		else
			@upload = Upload.new( params[:upload] )
			@upload.experiment_id = params['last_id']
			#render :text => @upload.inspect, :layout => false and return
			begin
				if @upload.save
					flash[:notice] = 'Upload succeeded!'
					redirect_to :controller => params[:last_controller], :action => params[:last_action], :id => params[:last_id]
				end
			rescue
				flash[:error] = "There was a problem while uploading the file. #{@upload.errors.full_messages.join('<br/>')} "

				if File.unlink( @upload.dump_filename  ) == 1
					logger.info("Cleanup of '#{@upload.dump_filename}' successful")
				else
					logger.error( "Can't cleanup '#{@upload.dump_filename}'" )
				end
				redirect_to :controller => params[:last_controller], :action => params[:last_action], :id => params[:last_id]
			end
		end
	end

	def list
		@uploads = Upload.find(:all, :order => 'updated_on')
	end

	def get_file
		@u = Upload.find( params[:id] )
		#headers["Content-type"] = @u.content_type
		send_file( @u.get_file, :type => @u.content_type, :disposition => 'inline' )
	end

	def destroy
		if Upload.find( params[:id] ).destroy
			logger.info("last_id: #{params['last_id']}")
			#redirect_to :controller => 'experiments', :action => "show", :id => params[:last_id]
			redirect_to session[:prev_loc]
		else
			flash[:notice] = "Cannot delete the result file #{params[:id]}"
			redirect_to session[:prev_loc]
		end
	end

	def edit
		@upload = Upload.find( params[:id] )
		@experiment = @upload.experiment
		#render :text => @upload.inspect
	end

	def update
			#render :text => params.inspect and return
			@upload = Upload.find( params[:upload_id] )
			@upload.update_attributes( params[:upload] )

			#render :text => (params[:tags]["Customer"] == "0").inspect
				if @upload.save
					logger.info("[upload record] #{@upload}")
					flash[:notice] = 'Experimental result was saved successfully!'
					redirect_to :controller => params[:last_controller], :action => params[:last_action], :id => params[:last_id]
				else
					flash[:notice] = "File was not saved. Please try again."
					redirect_to :controller => params[:last_controller], :action => params[:last_action], :id => params[:last_id]
				end
	end

end
