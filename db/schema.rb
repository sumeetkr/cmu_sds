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

ActiveRecord::Schema.define(:version => 20121203225303) do

  create_table "device_agents", :force => true do |t|
    t.string   "guid"
    t.string   "metadata_json"
    t.string   "network_address"
    t.string   "physical_location"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "device_id"
    t.string   "device_guid"
  end

  create_table "device_agents_devices", :force => true do |t|
    t.integer "device_id"
    t.integer "device_agent_id"
  end

  create_table "device_types", :force => true do |t|
    t.string   "device_type"
    t.string   "version"
    t.string   "manufacturer"
    t.string   "metadata_json"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "guid"
    t.string   "device_type_id"
    t.string   "metadata_json"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "network_address"
    t.string   "physical_location"
    t.integer  "sensor_id"
    t.integer  "device_agent_id"
    t.string   "device_agent_guid"
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
    t.string   "property_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "metadata_json"
  end

  create_table "sensors", :force => true do |t|
    t.string   "guid"
    t.string   "metadata_json"
    t.string   "sensor_type_id"
    t.integer  "min_value"
    t.integer  "max_value"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "device_guid"
    t.integer  "device_id",      :limit => 255
    t.string   "predecessor"
    t.integer  "gps_coord_lat"
    t.integer  "gps_coord_long"
    t.integer  "gps_coord_alt"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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
