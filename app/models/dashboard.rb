class Dashboard
  def initialize
  end
  
  def no_of_experiments
    Experiment.find(:all).length
  end
  
  def no_of_samples
    Sample.find(:all).length
  end
  
  def no_of_projects
    Project.find(:all).length
  end

	def no_of_uploads
		Upload.find(:all).length
  end
  
  def largest_experiment
    largest = 0
    largest_exp = nil
    Experiment.find(:all).each { |e| 
      if( e.samples.length > largest )
        largest = e.samples.length
        largest_exp = e
      end
    }
    if not largest_exp.nil?
      puts "[largest_experiment] returning the largest experiment object"
      largest_exp
    end
  end
    
end
