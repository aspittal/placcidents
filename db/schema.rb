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

ActiveRecord::Schema.define(:version => 20120207152645) do

  create_table "accidents", :force => true do |t|
    t.date   "event_date"
    t.string "location"
    t.string "country"
    t.float  "latitude"
    t.float  "longitude"
    t.string "airport_code"
    t.string "airport_name"
    t.string "injury_severity"
    t.string "aircraft_damage"
    t.string "aircraft_category"
    t.string "make"
    t.string "model"
    t.string "air_carrier"
    t.string "total_fatal_injuries"
    t.string "total_serious_injuries"
    t.string "total_minor_injuries"
    t.string "total_uninjured"
    t.string "weather_condition"
  end

end
