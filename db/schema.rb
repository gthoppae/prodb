# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121121175711) do

  create_table "experiments", :force => true do |t|
    t.integer  "project_id",              :default => 0,   :null => false
    t.string   "hypothesis",              :default => "",  :null => false
    t.string   "annotation"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "deleted",    :limit => 1, :default => "n"
  end

  add_index "experiments", ["project_id"], :name => "project_id"

  create_table "organisms", :force => true do |t|
    t.string   "species_name",      :limit => 100, :default => "", :null => false
    t.string   "strain_identifier", :limit => 100, :default => "", :null => false
    t.string   "relevant_genotype", :limit => 200, :default => "", :null => false
    t.string   "annotation",        :limit => 200
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "people", :id => false, :force => true do |t|
    t.integer  "id",                       :null => false
    t.string   "first_name", :limit => 50
    t.string   "last_name",  :limit => 50
    t.text     "address"
    t.string   "email",      :limit => 50
    t.string   "phone",      :limit => 15
    t.string   "fax",        :limit => 15
    t.datetime "created_on"
    t.datetime "updaed_on"
  end

  add_index "people", ["id"], :name => "id"

  create_table "projects", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "sample_origins", :force => true do |t|
    t.integer  "organism_id",                     :default => 0,  :null => false
    t.string   "description",      :limit => 100, :default => "", :null => false
    t.string   "condition",        :limit => 200, :default => "", :null => false
    t.string   "environment",      :limit => 200, :default => "", :null => false
    t.string   "tissue_type",      :limit => 100
    t.string   "cell_type",        :limit => 100
    t.string   "cell_cycle_phase", :limit => 100
    t.string   "technique",        :limit => 100
    t.string   "metabolic_label",  :limit => 100
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "samples", :force => true do |t|
    t.integer  "experiment_id",                        :default => 0,  :null => false
    t.integer  "sample_origin_id",                     :default => 0,  :null => false
    t.integer  "person_id"
    t.datetime "sample_date",                                          :null => false
    t.string   "provider",              :limit => 100, :default => "", :null => false
    t.string   "enriched_for",          :limit => 150
    t.string   "description"
    t.string   "annotation"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "sample_name",           :limit => 50,  :default => "", :null => false
    t.string   "stain",                 :limit => 20
    t.string   "analysis_type",         :limit => 50
    t.string   "bill_done",             :limit => 2
    t.text     "mascot_search_results"
  end

  add_index "samples", ["experiment_id"], :name => "experiment_id"
  add_index "samples", ["person_id"], :name => "person_id"
  add_index "samples", ["provider"], :name => "provider"
  add_index "samples", ["sample_date"], :name => "sample_date"
  add_index "samples", ["sample_origin_id"], :name => "sample_origin_id"

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tags_uploads", :id => false, :force => true do |t|
    t.integer "tag_id",    :default => 0, :null => false
    t.integer "upload_id", :default => 0, :null => false
  end

  create_table "uploads", :force => true do |t|
    t.string   "filename",      :limit => 100, :default => "",  :null => false
    t.float    "size",                         :default => 0.0, :null => false
    t.integer  "experiment_id",                :default => 0,   :null => false
    t.text     "description"
    t.datetime "created_on",                                    :null => false
    t.datetime "updated_on",                                    :null => false
    t.string   "content_type",  :limit => 100, :default => "",  :null => false
    t.string   "filepath"
  end

  add_index "uploads", ["experiment_id"], :name => "experiment_id"

end
