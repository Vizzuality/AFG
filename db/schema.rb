# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100705134101) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["action"], :name => "index_activities_on_action"
  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["item_type", "item_id"], :name => "index_activities_on_item_type_and_item_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "admin_passwords", :force => true do |t|
    t.string "password"
  end

  create_table "entries", :force => true do |t|
    t.integer  "guide_id"
    t.integer  "species_id"
    t.integer  "included_guide_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["guide_id"], :name => "index_entries_on_guide_id"
  add_index "entries", ["included_guide_id"], :name => "index_entries_on_included_guide_id"
  add_index "entries", ["position"], :name => "index_entries_on_position"
  add_index "entries", ["species_id"], :name => "index_entries_on_species_id"

  create_table "guides", :force => true do |t|
    t.string   "permalink"
    t.string   "name"
    t.string   "author"
    t.text     "description"
    t.integer  "species_count",   :default => 0
    t.integer  "downloads_count", :default => 0
    t.string   "session_id"
    t.integer  "popularity",      :default => 0
    t.boolean  "highlighted",     :default => false
    t.boolean  "published",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guides", ["author"], :name => "index_guides_on_author"
  add_index "guides", ["created_at"], :name => "index_guides_on_created_at"
  add_index "guides", ["name"], :name => "index_guides_on_name"
  add_index "guides", ["popularity"], :name => "index_guides_on_popularity"
  add_index "guides", ["session_id"], :name => "index_guides_on_session_id"

  create_table "pictures", :force => true do |t|
    t.integer  "species_id"
    t.string   "filename"
    t.string   "title"
    t.string   "caption"
    t.string   "photographer"
    t.string   "locality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "species", :force => true do |t|
    t.integer  "uid"
    t.string   "permalink"
    t.string   "name"
    t.integer  "guides_count",   :default => 0
    t.string   "genus"
    t.string   "family"
    t.string   "common_name"
    t.text     "description"
    t.string   "identification"
    t.text     "distribution"
    t.text     "ecology"
    t.text     "size"
    t.text     "depth"
    t.text     "reference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
