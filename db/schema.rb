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

ActiveRecord::Schema.define(:version => 20100811153300) do

  create_table "activities", :force => true do |t|
    t.column "user_id", :integer
    t.column "action", :string
    t.column "item_id", :integer
    t.column "item_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "activities", ["action"], :name => "index_activities_on_action"
  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["item_id", "item_type"], :name => "index_activities_on_item_type_and_item_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "admin_passwords", :force => true do |t|
    t.column "password", :string
  end

  create_table "entries", :force => true do |t|
    t.column "guide_id", :integer
    t.column "species_id", :integer
    t.column "included_guide_id", :integer
    t.column "position", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "entries", ["guide_id"], :name => "index_entries_on_guide_id"
  add_index "entries", ["included_guide_id"], :name => "index_entries_on_included_guide_id"
  add_index "entries", ["position"], :name => "index_entries_on_position"
  add_index "entries", ["species_id"], :name => "index_entries_on_species_id"

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /Users/fernando/proyectos/afg/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:52:in `table'/Users/fernando/proyectos/afg/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'/Users/fernando/proyectos/afg/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/schema_dumper.rb:75:in `tables'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/schema_dumper.rb:66:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/schema_dumper.rb:66:in `tables'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/schema_dumper.rb:27:in `dump'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/schema_dumper.rb:21:in `dump'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/railties/databases.rake:325/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/railties/databases.rake:324:in `open'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/railties/databases.rake:324/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:636:in `call'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:631:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/Users/fernando/.rvm/rubies/ruby-1.8.7-p174/lib/ruby/1.8/monitor.rb:242:in `synchronize'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@rails3/gems/activerecord-3.0.0.rc/lib/active_record/railties/databases.rake:141/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:636:in `call'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:631:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/Users/fernando/.rvm/rubies/ruby-1.8.7-p174/lib/ruby/1.8/monitor.rb:242:in `synchronize'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2051:in `invoke_task'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2029:in `each'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2023:in `top_level'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2001:in `run'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/lib/rake.rb:1998:in `run'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/gems/rake-0.8.7/bin/rake:31/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/bin/rake:19:in `load'/Users/fernando/.rvm/gems/ruby-1.8.7-p174@global/bin/rake:19

  create_table "guides", :force => true do |t|
    t.column "permalink", :string
    t.column "name", :string
    t.column "author", :string
    t.column "description", :text
    t.column "species_count", :integer, :default => 0
    t.column "downloads_count", :integer, :default => 0
    t.column "session_id", :string
    t.column "popularity", :integer, :default => 0
    t.column "highlighted", :boolean, :default => false
    t.column "published", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "guides", ["author"], :name => "index_guides_on_author"
  add_index "guides", ["created_at"], :name => "index_guides_on_created_at"
  add_index "guides", ["name"], :name => "index_guides_on_name"
  add_index "guides", ["popularity"], :name => "index_guides_on_popularity"
  add_index "guides", ["session_id"], :name => "index_guides_on_session_id"

  create_table "pictures", :force => true do |t|
    t.column "species_id", :integer
    t.column "filename", :string
    t.column "title", :string
    t.column "caption", :string
    t.column "photographer", :string
    t.column "locality", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

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
    t.column "identification", :string
    t.column "distribution", :text
    t.column "ecology", :text
    t.column "size", :text
    t.column "depth", :text
    t.column "reference", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "kingdom", :string
    t.column "phylum", :string
    t.column "t_class", :string
    t.column "t_order", :string
    t.column "featured", :boolean, :default => false
    t.column "imported_file", :string
    t.column "species", :string
  end

end
