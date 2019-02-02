# frozen_string_literal: true

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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_202_132_430) do
  create_table 'items', force: :cascade do |t|
    t.string 'file_number'
    t.integer 'version'
    t.string 'name'
    t.string 'item_type'
    t.string 'title'
    t.string 'action'
    t.string 'result'
    t.integer 'meeting_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'link'
    t.index ['meeting_id'], name: 'index_items_on_meeting_id'
  end

  create_table 'meetings', force: :cascade do |t|
    t.string 'name'
    t.date 'date'
    t.string 'details'
    t.string 'agenda'
    t.string 'minutes'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
