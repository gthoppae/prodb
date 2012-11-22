module ToolsHelper

#constants
MASCOT_ROOT = "/usr/local/mascot/current"
MASCOT_CONFIG_FILE = "#{MASCOT_ROOT}/config/mascot.dat"
MASCOT_SEQUENCES = "#{MASCOT_ROOT}/sequence"

	def get_db_list
		# open the mascot config file, read the PAF generated databases
		# and print the database names alone
		@lines = File.open(MASCOT_CONFIG_FILE, "r").readlines[28,40-28]
		@dblist = Hash.new
		@dblists = Array.new
		@db_files = Array.new
		@lines.each do |l|
			@dblist = {}
			line = l.strip.split(' ')
			@dblist[ 'name' ] = line[0] 
			@dblists.push(@dblist)
			#] =  line[1]
		end
		return @dblists
	end

	def get_db(dbname)
		if (@dblist.include?(dbname))
			dir = Dir.new("#{MASCOT_SEQUENCES}/#{dbname}/current/")
			dir.to_a.each do |d|
				if (d =~ /fasta/)
					@db_files.push( d )
				end
			end
		end
		return @db_files
	end

	def get_sequences( dbname, dbfile )
		xs = []
		file = File.open("#{MASCOT_SEQUENCES}/#{dbname}/current/#{dbfile}").read.split(/>/)
		file.shift
		#puts "first item: #{file[0]}"
		file.each do |l|
				f = l.split(/\n/)
				x = {}
				x['id'] = f[0].strip
				#t = ""
				#f[1].strip.split('').each do |s|
				#	if ('AGILPV'.split('').member?(s))
				#		t	= t + "<font color='#0000ff'>#{s}</font>"
				#	elsif ('FYW'.split('').member?(s))
				#		t	= t + "<font color='#ff0000'>#{s}</font>"
				#	elsif ('DENQRHSTK'.split('').member?(s))
				#	 	t	= t + "<font color='#00ff00'>#{s}</font>"
				#	elsif ('CM'.split('').member?(s))
				#	 	t = t + "<font color='#ffff00'>#{s}</font>"
				#	else
				#		t = t + "<font color='#000000'>#{s}</font>"
				#	end
				#end
				x['seq'] = f[1].strip
				xs.push(x)
			end
			puts xs[0]
		#puts xs
		return xs
	end


	def search(dbname, dbfile, str)
	    file = File.open("#{MASCOT_SEQUENCES}/#{dbname}/current/#{dbfile}").read.split(/>/)	
	end

	def update_sequences(dbname, dbfile, sequences)
			file = File.open("#{MASCOT_SEQUENCES}/#{dbname}/current/#{dbfile}", "w")
			file.write(sequences)
			file.close()
	end

end
