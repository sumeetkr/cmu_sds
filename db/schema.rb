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

ActiveRecord::Schema.define(:version => 0) do

  create_table "device_agents", :force => true do |t|
    t.string   "guid"
    t.string   "metadata"
    t.string   "network_address"
    t.string   "physical_location"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "device_registries", :force => true do |t|
    t.string   "device_guid"
    t.string   "device_id"
    t.string   "device_agent_id"
    t.string   "device_agent_guid"
    t.string   "network_address"
    t.string   "physical_location"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "device_types", :force => true do |t|
    t.string   "type"
    t.string   "version"
    t.string   "manufacturer"
    t.string   "metadata"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "guid"
    t.string   "device_type_id"
    t.string   "metadata"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "network_address"
    t.string   "physical_location"
    t.integer  "sensor_id"
  end

  create_table "sensor_readings", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sensor_type_registries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sensor_types", :force => true do |t|
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sensors", :force => true do |t|
    t.string   "guid"
    t.string   "metadata"
    t.string   "sensor_type_id"
    t.integer  "min_value"
    t.integer  "max_value"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "device_guid"
    t.string   "device_id"
    t.string   "predecessor",    :default => "null"
    t.integer  "gps_coord_lat"
    t.integer  "gps_coord_long"
    t.integer  "gps_coord_alt"
  end

  create_table "virtual_devices", :force => true do |t|
    t.string   "guid"
    t.string   "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "virtual_sensor_registries", :force => true do |t|
    t.string   "virtual_sensor_id"
    t.string   "sensor_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "virtual_sensors", :force => true do |t|
    t.string   "guid"
    t.string   "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
