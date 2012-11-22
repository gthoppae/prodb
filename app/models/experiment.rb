class Experiment < ActiveRecord::Base
	
	belongs_to :project
	has_many :samples, :order => 'id ASC', :dependent => :destroy
	has_many :uploads, :dependent => :destroy

	def human_created_on
		if not attributes["created_on"].nil?
			attributes["created_on"].strftime( "%d %B, %Y %H:%M hrs" )
		end
	end

	def human_created_on_short
		if not attributes["created_on"].nil?
			attributes["created_on"].strftime( "%d %b, %Y" )
		end
	end

			#source: http://wiki.rubyonrails.org/rails/pages/FullTextSearch

			def find_by_text(text, orderings = nil, limit = nil, joins = nil)
        keywords = text.split(' ')
        find_by_keywords(keywords)
      end
 
      def find_by_keywords(keywords, orderings = nil, limit = nil, joins = nil)
        # TODO: should do less conservative sanitizing, since we know
        # that these will go inside SQL string, so characters like ':'
        # or ';' are OK.  Also, need to escape \%_ characters (these
        # have special meaning to LIKE)
        #
        # LIKE documentation:
        #   <a href="http://www.postgresql.org/docs/7.1/interactive/functions-matching.html">http://www.postgresql.org/docs/7.1/interactive/functions-matching.html</a>
        #   <a href="http://dev.mysql.com/doc/mysql/en/Pattern_matching.html">http://dev.mysql.com/doc/mysql/en/Pattern_matching.html</a>
        #   <a href="http://dev.mysql.com/doc/mysql/en/Case_sensitivity.html">http://dev.mysql.com/doc/mysql/en/Case_sensitivity.html</a>
        keywords.collect! { |keyword| sanitize(keyword) }

        # build condition in the form of
        #   (name LIKE '%artist%' OR description LIKE '%artist%')
        #   AND (name LIKE '%David%' OR description LIKE '%David%')
        condition = keywords.collect { |keyword|
          '(' + ['hypothesis', 'annotation'].collect { |column|
            "#{column.name} LIKE '%#{keyword}%'" 
          }.join(' OR ') + ')'
        }.join(' AND ')

        find_all(condition, orderings, limit, joins)
      end

			def annotation
					if attributes['annotation'].empty?
						"-"
					else
						attributes['annotation']
					end
			end


end
