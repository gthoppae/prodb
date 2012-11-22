class ModifySamplesAnalysisType < ActiveRecord::Migration
  def up
	change_column( :samples, :analysis_type, :string, {:limit => 50})
  end

  def down
	change_column( :samples, :analysis_type, :string, {:limit => 20})
  end
end
