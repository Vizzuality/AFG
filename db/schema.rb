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

ActiveRecord::Schema.define(:version => 20100624141849) do

  create_table "guides", :force => true do |t|
    t.string   "name"
    t.string   "author"
    t.text     "description"
    t.integer  "species_count",   :default => 0
    t.integer  "downloads_count", :default => 0
    t.string   "session_id"
    t.integer  "loving",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guides", ["author"], :name => "index_guides_on_author"
  add_index "guides", ["created_at"], :name => "index_guides_on_created_at"
  add_index "guides", ["loving"], :name => "index_guides_on_loving"
  add_index "guides", ["name"], :name => "index_guides_on_name"

end
