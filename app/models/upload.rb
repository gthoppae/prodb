class Upload < ActiveRecord::Base
	belongs_to :experiment
	after_destroy :destroy_file
	validates_presence_of :filename
	acts_as_taggable

	
	def file=(file_field)
		@file = file_field
		orig_fname = file_field.original_filename
		logger.info("Originial filename is #{orig_fname}")
		self.filename = base_part_of( orig_fname )
		logger.info("Sane filename is #{self.filename}")
		if self.content_type.nil? #or self.content_type.empty?
			self.content_type = 'application/octet-stream'
		else
			self.content_type = file_field.content_type.strip
		end
		self.size = @file.size
	end

	def validate_on_create
		if @file.size < 0
			errors.add_to_base( "File size is invalid" )
		end
	end

	def before_create
		dirname = dump_dirname

		logger.info( "Creating dir '#{dirname}'" )
		FileUtils.mkdir_p dirname

		filename = dump_filename
		logger.info( "Uploading file to '#{filename}'" )
		@file.rewind
		File.open(filename, "wb") do |f| 
			f.write(@file.read)
		end
		self.filepath = dirname
	end

	def dump_filename( )
		# DUMP_PATH is set in config/environment.rb
		File.expand_path( File.join( dump_dirname, "#{self.filename}") )
	end

	def dump_dirname
		if self.created_on.nil?
			self.created_on = Time.now
		end
		File.join(DUMP_PATH, self.experiment.project.name.gsub(' ', '_'), self.experiment.id.to_s + "-" + self.experiment.hypothesis.gsub( %r{^\.|[\s/\\\*\:\?'"<>\|]}, '_'), self.created_on.strftime('%Y-%m-%d') )
	end


	def get_file
			#logger.info( "dump_filename: #{dump_filename()}" )
			if self.filepath.nil? or self.filepath.empty? # in case of data migration
				File.join( dump_dirname, self.filename )
			else
				File.join(self.filepath, self.filename)
			end
	end

	
	private

	def base_part_of( filename )
		filename = File.basename( filename.strip )
		# remove leading period, whitespace and \ / : * ? " ' < > |
		filename = filename.gsub( %r{^\.|[\s/\\\*\:\?'"<>\|]}, '_')
	end

	def destroy_file
		if File.exists?( File.join( self.filepath, self.filename ) )
			FileUtils.rm(self.filepath + '/' + self.filename)
			logger.info("Deleted file: " + self.filename )
		else
			logger.info("No file exists to delete!")
		end
	end

end
