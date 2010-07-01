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

ActiveRecord::Schema.define(:version => 20100701093527) do

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

  create_table "choices", :force => true do |t|
    t.integer  "guide_id"
    t.integer  "species_id"
    t.integer  "included_guide_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["guide_id"], :name => "index_choices_on_guide_id"
  add_index "choices", ["included_guide_id"], :name => "index_choices_on_included_guide_id"
  add_index "choices", ["position"], :name => "index_choices_on_position"
  add_index "choices", ["species_id"], :name => "index_choices_on_species_id"

  create_table "guides", :force => true do |t|
    t.string   "name"
    t.string   "author"
    t.text     "description"
    t.integer  "species_count",   :default => 0
    t.integer  "downloads_count", :default => 0
    t.string   "session_id"
    t.integer  "popularity",      :default => 0
    t.boolean  "highlighted",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guides", ["author"], :name => "index_guides_on_author"
  add_index "guides", ["created_at"], :name => "index_guides_on_created_at"
  add_index "guides", ["name"], :name => "index_guides_on_name"
  add_index "guides", ["popularity"], :name => "index_guides_on_popularity"
  add_index "guides", ["session_id"], :name => "index_guides_on_session_id"

  create_table "species", :force => true do |t|
    t.string   "name"
    t.integer  "guides_count", :default => 0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
