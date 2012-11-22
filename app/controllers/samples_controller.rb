class SamplesController < ApplicationController
	layout 'application', :except => [:list_filtered]

  def index
    list
    render :action => 'list'
  end

  def list_by
    if params[:id]
      @samples = Sample.paginate :page => params[:page], :order => "#{params[:id]} DESC", :per_page => 10
    else
      @samples = Sample.paginate :page => params[:page], :order => "created_on DESC", :per_page => 10
    end
		render :template => 'samples/list'
  end


	def list
  	@samples = Sample.paginate :page => params[:page], :conditions => ["experiment_id IS NOT NULL"], :order => "sample_date DESC", :per_page => 10
		respond_to do |format|
			format.html {
				if not params.include?(:page)
					params[:page] = 1
				end
			}
			format.xml {
				@samples.to_xml
			}
		end
	end


	def list_filtered
		if params[:sample][:provider].empty?
			list
			render :partial => "samples_table"
		else
			@samples = Sample.find( :all, :conditions => ['provider LIKE ?', params[:sample][:provider] ] )	
			#render :text => @samples.collect(&:sample_name).inspect 
		end
	end

  def show
    @sample = Sample.find(params[:id])
  end

  def new
		if not params[:id].nil?
			#@project = Project.find( params["project_id"]
			@experiment = Experiment.find( params["id"])
    	@sample = Sample.new
			#render_text params.inspect
		else
			@experiment = Experiment.new
			@sample = Sample.new
		end
  end

	def get_mascot_link
		x = `grep '^#{params[:id]}' /usr/local/mascot/current/logs/searches.log`
		s = x.split("\t")[6]
		url = "http://pcib306.unil.ch/mascot/cgi/master_results.pl?file="
		redirect_to url + s
	end

  def create
    @sample = Sample.new(params[:sample])
    if @sample.save
      flash[:notice] = 'Sample was successfully created.'
			@prev_id = @sample.experiment_id
      redirect_to "/experiments/show/#{@prev_id}"
    else
      render :action => 'new'
    end
  end

  def edit
    @sample = Sample.find(params[:id])
		@prev_id = @sample.experiment_id
		@prev_action = "/experiments/show"
		@experiment = Experiment.find( @prev_id )
  end

  def update
    @sample = Sample.find(params[:id])
		#render :text => params.inspect and return
		@sample['mascot_search_results'] = params[:mascot_search_results].join(",")
		#params[:sample]['mascot_search_results'] = @sample.mascot_search_results}
		#render_text params.inspect
		#logger.info( @sample.mascot_search_results)
    if @sample.update_attributes(params[:sample])
      flash[:notice] = 'Sample was successfully updated.'
      #flash[:notice] = params[:sample_origin_id]
      redirect_to "/experiments/show/#{@sample.experiment_id}"
    else
      render_action 'edit'
    end
  end

	def destroy_multiple
		render :text => params.inspect and return
	end

  def destroy
    Sample.find(params[:id]).destroy
    redirect_to session[:prev_loc]
  end

	def edit_with_ajax
		logger.info("received update request for #{params[:id]}")
		@sample = Sample.find( params[:id] )
		render :partial => "partials/edit_sample_for_experiment", :locals => { :name => "sample" }
	end

	def search_mascot_searchlog
		@results = ""
		@phrase = request.raw_post || request.query_string
		
		if @phrase.length > 3
			x = []
			@matches = `grep '#{@phrase}' /usr/local/mascot/current/logs/searches.log`
			@matches.split("\n").each { |s| 
				n = s.strip.split("\t")
				#checkbox  = "<input type='checkbox' name='#{n[0]}' value='#{n[6]}'/>"
				x << [ s ]
			}
			#puts "Matches: #{@matches}"
			@results = x.join("\n")
		end
		render_without_layout 
	end


	def import_new

		@experiment = Experiment.find(params[:id])
		if request.post?
			render :text => "received"
		else
			# do something
		end

	end


	def import
		@samples = []

		@experiment_id = params['experiment']['id']
		params['samples']['import'].split(/\n/).each do |s|
			@samples <<  s.strip.split(/\t/)
		end

		columns = [
									:experiment_id,
									:sample_name,
									:sample_date, 
									:provider,
									:annotation,
									:description,
									:stain,
									:analysis_type,
									:bill_done
							]
		values = @samples.collect{ |c| 
		
								[ @experiment_id, 
									c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7],
								]

							}

		#render :text => values.inspect and return
		Sample.import columns, values, {:validate => false}
	
		#@s = Sample.new		
		# if Person.find_by_last_name(@samples[0][2].downcase).nil?
		# @s.errors.add "Contact '" + @samples[0][2].downcase + "' is not found in the database."
		# end
			
		#@s.bulk_import( @samples, @experiment_id )
		#render :text => @samples.inspect


		flash[:notice] = "#{@samples.length} samples successfully imported"
		redirect_to "/experiments/show/#{@experiment_id}"

	end


	def update_multiple

		case params[:submit]

			when "Delete"
				#destroy_multiple
				#render :text => params[:experiment].inspect and return
				params[:sample][:selected_sample].each do |s|
					Sample.find( s ).destroy
				end
				flash[:notice] = "#{params[:sample][:selected_sample].length} samples selected: Delete successful"
				redirect_to "/experiments/show/#{params[:experiment][:id]}"

			when  "Update"
				
				params[:sample][:selected_sample].each do |s|
					s = Sample.find(s, :include => :sample_origin)
			
					if (not params[:sample][:provider].empty?)
							s.provider = Person.find(params[:sample][:provider]).last_name
					end
					if	params[:sample].keys.include?('sample_name') and not params[:sample]['sample_name'].empty?
							s.sample_name = params[:sample]['sample_name']
					end
					if params[:sample].keys.include?('sample_date') and not params[:sample]['sample_date'].strip.empty?
							s.sample_date = params[:sample][:sample_date].to_date.strftime('%Y-%m-%d')
					end
					if params[:sample].keys.include?('description') and not params[:sample]['description'].empty?
							s.description = params[:sample][:description]
					end
					if params[:sample].keys.include?('annotation') and not params[:sample]['annotation'].empty?
							s.annotation= params[:sample][:annotation]
					end
					if params[:sample].keys.include?('bill_done') and not params[:sample]['bill_done'].empty?
							s.bill_done = params[:sample][:bill_done]
					end
					if params[:sample].keys.include?('stain') and not params[:sample]['stain'].empty?
							s.stain = params[:sample][:stain]
					end
					if params[:sample].keys.include?('analysis_type') and not params[:sample]['analysis_type'].empty?
							s.analysis_type = params[:sample][:analysis_type]
					end
					if params[:sample].keys.include?('mascot') and not params[:sample]['mascot'].empty?
							s.mascot_search_results = params[:sample][:mascot]
					end
					#render :text => s.attributes.inspect + "<br/><br/>" + params.inspect  and return
					if s.save
						flash.now[:notice] = "saved sample " + s.sample_name
					else
						flash.now[:warning] = "can't save sample " + s.sample_name
					end
				end #params
				#render :partial => 'experiments/show_samples_for_experiment', :locals => { :experiment => s.experiment.id }
				redirect_to "/experiments/show/#{params[:experiment][:id]}"

		end #case

	end # update_multiple

end

