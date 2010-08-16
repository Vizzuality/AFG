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

ActiveRecord::Schema.define(:version => 20100816120620) do

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
    t.column "element_id", :string
    t.column "element_type", :string
    t.column "position", :integer
    t.column "elements_count", :integer, :default => 0
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

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
  end

  add_index "guides", ["author"], :name => "index_guides_on_author"
  add_index "guides", ["created_at"], :name => "index_guides_on_created_at"
  add_index "guides", ["name"], :name => "index_guides_on_name"
  add_index "guides", ["popularity"], :name => "index_guides_on_popularity"
  add_index "guides", ["session_id"], :name => "index_guides_on_session_id"

  create_table "landscapes", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "source", :string
    t.column "description", :text
    t.column "related_url", :string
    t.column "image1_url", :string
    t.column "image2_url", :string
    t.column "image3_url", :string
    t.column "image4_url", :string
    t.column "guides_count", :integer, :default => 0
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

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
    t.column "complete", :boolean, :default => false
  end

end
