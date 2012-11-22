class ToolsController < ApplicationController
	
#constants
MASCOT_ROOT = "/usr/local/mascot/current"
MASCOT_CONFIG_FILE = "#{MASCOT_ROOT}/config/mascot.dat"
MASCOT_SEQUENCES = "#{MASCOT_ROOT}/sequence"

	def index
	end

	def unescape
		@unescaped_text = CGI.unescape( params[:text] )
	end

	def seq_viewer
		@dbname = 'custom'
		@dbfile = get_dbfile @dbname

		seqs = get_sequences(@dbname, @dbfile)

		@formatted_seq = ""
		seqs.each do |s|
			@formatted_seq = @formatted_seq + ">#{s['id']}"
			seq = ""
			arr = s['seq'].split(/(..........)/)
			arr.insert(-2, "")
			arr.each_with_index do |l, i|
				if l.empty? 
					seq = seq + " "
				end	
				if ((i%14) == 0) 
					seq = seq + l + "\n"
				else 
					seq = seq + l
				end
			#	end #split.each
				#seq = seq + l
			end #seqs.each
			@formatted_seq = @formatted_seq + seq + "\n"
		end
		#@formatted_seq.sub(/\^M/, '')
	end

	def seq_editor
		if request.post?
			f = File.open("/usr/local/mascot/current/sequence/" + params[:dbname] + "/current/" + params[:dbfile], File::WRONLY|File::APPEND)
			#f.write("\n")
			######## Remove extra whitespace in protein sequences 
			input = params[:sequences].strip 
			finalinput = nil

			sequence = nil
			indexline = 0
			input.each_line{ |line|
			        if line =~ /^>/ then
					line.chomp!
					if indexline == 0 then
						finalinput = "#{line}\n"
						indexline += 1
					else
			                	finalinput = "#{finalinput}#{sequence}\n#{line}\n"
					end
			                sequence = nil
			                next
		        	end
			        line.gsub!(/[^A-Za-z]/, "")
			        sequence = "#{sequence}#{line}"
			}

			finalinput = "#{finalinput}#{sequence}"
			##############

                        #f.write( params[:sequences].strip ) 
			f.write( finalinput )
			f.write( "\n" )
			f.close
			redirect_to :action => "seq_viewer"
			#render :text => "yes, writable" if file.writable?
      #file.write(sequences)
      #file.close()
			#update_sequences('custom', 'custom_020807.fasta', params[:sequences] )
		else
			@dbname = 'custom'
			@dbfile = get_dbfile @dbname
		end 
	end

private
  def get_sequences( dbname=dbname, dbfile=dbfile )
    xs = []
    		file = File.open("#{MASCOT_SEQUENCES}/#{dbname}/current/#{dbfile}").read.split(/^>/)
    		file.shift
    		file.each do |l|
        		f = l.split(/\n/)
        		x = {}
        		x['id'] = f[0].strip
						t = f[1,f.length].to_s
        		x['seq'] = t
        		xs.push(x)
      		end
    		return xs
	end

	def get_dbfile( dbname=dbname )
		Dir.entries("#{MASCOT_SEQUENCES}/#{dbname}/current").collect { |e| e =~ /custom_(\d+).fasta$/ ? e : nil }.compact.to_s
	end




	def colorize(str)
        t = ""
        str.split('').each do |s|
         if ('AGILPV'.split('').member?(s))
           t = t + "<font color='#0000ff'>#{s}</font>"
         elsif ('FYW'.split('').member?(s))
           t = t + "<font color='#ff0000'>#{s}</font>"
         elsif ('DENQRHSTK'.split('').member?(s))
           t = t + "<font color='#00ff00'>#{s}</font>"
         elsif ('CM'.split('').member?(s))
           t = t + "<font color='#ffff00'>#{s}</font>"
         else
           t = t + "<font color='#000000'>#{s}</font>"
         end
        end
				return t
	end

end
