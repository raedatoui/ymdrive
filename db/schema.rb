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

ActiveRecord::Schema.define(:version => 20130702161020) do

  create_table "formats", :force => true do |t|
    t.string   "label"
    t.string   "format"
    t.string   "mimetype"
    t.string   "icon"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "extension"
  end

  create_table "g_files", :force => true do |t|
    t.string   "file_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "path"
  end

end
