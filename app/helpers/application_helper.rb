# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def mascot_links( s )
		res = ""
		links = []
		logger.info("Inspecting sample: " +  s.sample_name )
		link = "http://pcib306.unil.ch/mascot/cgi/master_results.pl?file="
		logger.info( "before mascot_search_results" )
		logger.info( "mascot_search_results: " + s.mascot_search_results.to_s )
		res = s.mascot_search_results
		logger.info( "after mascot_search_results" )
		if( not res.nil? ) 
			if (not res.empty?)
			logger.info( "!!not empty or not nil" )
			x = res.split(/,/)
			if (x.length == 1)
				search_log = `grep '^#{x[0]}' /usr/local/mascot/current/logs/searches.log`
				if search_log.empty?
					logger.info("search_log is empty")
					""
				else
					#logger.info("search_log.length: #{search_log.length}")
					search_log = search_log.split("\t")
					logger.info( "<a href='#{link + search_log[6]}'>x[0]</a>" )
					"<a href='#{link + search_log[6]}' target='_new'>#{x[0]}</a>"
				end
			else
				x.each { |e|
					e.strip!
					search_log = `grep '^#{e}' /usr/local/mascot/current/logs/searches.log`
					search_log = search_log.split("\t")
					logger.info( "<a href='#{link + search_log[6]}'>e</a>" )
					links << "<a href='#{link + search_log[6]}' target='_new'>#{e}</a>"
				}
				links.join(', ')
			end
			end
		else
			logger.info( "!!empty or nil\n" )
		end
	end

	def alphabet_links( )
		str = "<div style=\"font-size: large\">"
		str = str + "<a href=\"?starts_with=\">All</a>"
		("A".."Z").to_a.each { |a|
			str = str + " <a href=\"?starts_with=#{a}\">" + a + "</a> "
		}
		str + "</div>"

	end


	def show_icon( doc )
		case doc 
			when /powerpoint/
				icon = 'page_white_powerpoint.png'
			when /excel|xls|xlt/
				icon = 'page_white_excel.png'
			when /word/
				icon = 'page_white_word.png'
			when /text/
				icon = 'page_white_text.png'
			when /image/
				icon = 'page_white_picture.png'
			when /zip/
				icon = 'page_white_zip.png'
			when /acrobat|pdf/
				icon = 'page_white_acrobat.png'
			else
				icon = 'page_white.png'
		end
		image_tag("silk_icons/#{icon}", :alt=>"#{doc}")
	end
end
