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

ActiveRecord::Schema.define(:version => 20100921082035) do

  create_table "admin_passwords", :force => true do |t|
    t.column "password", :string
  end

  create_table "entries", :force => true do |t|
    t.column "guide_id", :integer
    t.column "element_id", :string
    t.column "element_type", :string
    t.column "position", :integer
    t.column "elements_count", :integer, :default => 0
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "entries", ["guide_id", "created_at"], :name => "idx_guide_id_created_at"
  add_index "entries", ["guide_id", "element_id", "element_type"], :name => "idx_guide_id_e_type_and_e_id"
  add_index "entries", ["guide_id", "element_type"], :name => "idx_guide_id_element_type"
  add_index "entries", ["guide_id"], :name => "index_entries_on_guide_id"

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/bundler/gems/postgis_adapter-d2240d7/lib/postgis_adapter/common_spatial_adapter.rb:52:in `table'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/bundler/gems/postgis_adapter-d2240d7/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/bundler/gems/postgis_adapter-d2240d7/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/schema_dumper.rb:75:in `tables'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/schema_dumper.rb:66:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/schema_dumper.rb:66:in `tables'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/schema_dumper.rb:27:in `dump'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/schema_dumper.rb:21:in `dump'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/railties/databases.rake:327/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/railties/databases.rake:326:in `open'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/railties/databases.rake:326/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:636:in `call'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:631:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/Users/fernando/.rvm/rubies/ruby-1.8.7-p174/lib/ruby/1.8/monitor.rb:242:in `synchronize'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0/lib/active_record/railties/databases.rake:143/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:636:in `call'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:631:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/Users/fernando/.rvm/rubies/ruby-1.8.7-p174/lib/ruby/1.8/monitor.rb:242:in `synchronize'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2051:in `invoke_task'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2029:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2023:in `top_level'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2001:in `run'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/lib/rake.rb:1998:in `run'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/rake-0.8.7/bin/rake:31/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/bin/rake:19:in `load'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/bin/rake:19

  create_table "guides", :force => true do |t|
    t.column "permalink", :string
    t.column "name", :string
    t.column "author", :string
    t.column "description", :text
    t.column "species_count", :integer, :default => 0
    t.column "landscapes_count", :integer, :default => 0
    t.column "downloads_count", :integer, :default => 0
    t.column "session_id", :string
    t.column "popularity", :integer, :default => 0
    t.column "highlighted", :boolean, :default => false
    t.column "published", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "last_action", :string
    t.column "pdf_file", :string
  end

  add_index "guides", ["highlighted", "published"], :name => "index_guides_on_published_and_highlighted"
  add_index "guides", ["session_id"], :name => "index_guides_on_session_id"

  create_table "landscape_pictures", :force => true do |t|
    t.column "original_image_url", :string
    t.column "landscape_id", :integer
    t.column "image_file_name", :string
    t.column "image_content_type", :string
    t.column "image_file_size", :integer
    t.column "image_updated_at", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "landscape_pictures", ["landscape_id"], :name => "index_landscape_pictures_on_landscape_id"

  create_table "landscapes", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "description", :text
    t.column "related_url", :string
    t.column "image1_url", :string
    t.column "image2_url", :string
    t.column "image3_url", :string
    t.column "image4_url", :string
    t.column "guides_count", :integer, :default => 0
    t.column "radius", :integer, :default => 50000
    t.column "featured", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :point, :srid => 4326, :null => false
    t.column "source_link", :string
    t.column "source_name", :string
    t.column "image1_description", :text
    t.column "image2_description", :text
    t.column "image3_description", :text
    t.column "image4_description", :text
  end

  add_index "landscapes", ["featured"], :name => "index_landscapes_on_featured"
  add_index "landscapes", ["the_geom"], :name => "index_landscapes_on_the_geom", :spatial=> true 

  create_table "occurrences", :force => true do |t|
    t.column "species_id", :integer
    t.column "date", :date
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :point, :srid => 4326, :null => false
  end

  add_index "occurrences", ["species_id"], :name => "index_occurrences_on_species_id"
  add_index "occurrences", ["the_geom"], :name => "index_occurrences_on_the_geom", :spatial=> true 

  create_table "pictures", :force => true do |t|
    t.column "species_id", :integer
    t.column "filename", :string
    t.column "title", :string
    t.column "caption", :string
    t.column "photographer", :string
    t.column "locality", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "image_file_name", :string
    t.column "image_content_type", :string
    t.column "image_file_size", :integer
    t.column "image_updated_at", :datetime
    t.column "description", :text
  end

  add_index "pictures", ["species_id"], :name => "index_pictures_on_species_id"

  create_table "species", :force => true do |t|
    t.column "uid", :integer
    t.column "permalink", :string
    t.column "name", :string
    t.column "guides_count", :integer, :default => 0
    t.column "highlighted", :boolean, :default => false
    t.column "genus", :string
    t.column "family", :string
    t.column "common_name", :string
    t.column "description", :text
    t.column "identification", :text
    t.column "distribution", :text
    t.column "ecology", :text
    t.column "size", :text
    t.column "depth", :text
    t.column "reference", :text
    t.column "complete", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "kingdom", :string
    t.column "phylum", :string
    t.column "t_class", :string
    t.column "t_order", :string
    t.column "featured", :boolean, :default => false
    t.column "imported_file", :string
    t.column "species", :string
    t.column "habitat", :text
    t.column "distinguishing_characters", :text
    t.column "source_link", :string
    t.column "source_name", :string
  end

  add_index "species", ["complete"], :name => "index_species_on_complete"
  add_index "species", ["family"], :name => "index_species_on_family"
  add_index "species", ["genus"], :name => "index_species_on_genus"
  add_index "species", ["kingdom"], :name => "index_species_on_kingdom"
  add_index "species", ["phylum"], :name => "index_species_on_phylum"
  add_index "species", ["t_class"], :name => "index_species_on_t_class"
  add_index "species", ["t_order"], :name => "index_species_on_t_order"
  add_index "species", ["uid"], :name => "index_species_on_uid"

  create_table "taxonomies", :force => true do |t|
    t.column "name", :string
    t.column "hierarchy", :string
    t.column "downloads_count", :integer, :default => 0
    t.column "description", :text
    t.column "distinguishing_characters", :text
    t.column "parents", :string
  end

  add_index "taxonomies", ["name", "hierarchy"], :name => "idx_hierarchy_name"

end
