require "aws"

namespace :db do

  desc "Runs database migrations"
  task :migrate_all do
    puts "Started test db migration."
    puts `rake db:migrate RAILS_ENV=test`
    puts "Finished test db migration."

    puts "Started development db migration."
    puts `rake db:migrate RAILS_ENV=development`
    puts "Finished development db migration."

    puts "Started production db migration."
    puts `rake db:migrate RAILS_ENV=production`
    puts "Finished production db migration."
  end

  desc "empty the database by reloading the schema"
  task :empty do
    puts "Started loading schema for test."
    puts `rake db:test:load`
    puts "Finished loading schema for test."

    puts "Started loading schema for development and production."
    puts `rake db:schema:load`
    puts "Finished loading schema for development and production."
  end

  desc "Fill database with sample data. Contains two methods, one for populating sensor readings in DynamoDB and the other a relational DB."
  task :populate => [:environment] do
    #Call methods to populate db
    #populate_dynamodb
    populate_sqldb
    populate_conversions_table
    puts "Finished populating the database."
  end

  desc "re-populate the database with sample data"
  task :repopulate => [:migrate_all, :empty, :populate] do
  end


  desc "re-populate the database with sample data without migrating"
  task :repopulate_without_migrate => [:empty, :populate] do
  end

  def populate_dynamodb
    # create a table (10 read and 5 write capacity units) with the
    # default schema (id string hash key)
    # do nothing if table exists
    db = AWS::DynamoDB.new
    dynamodb_tables = {}

    sensor_readings_table_name = "SensorReadingsV4"

    {
        sensor_readings_table_name => {
            hash_key: {id: :string},
            range_key: {timestamp: :number}
        }
    }.each_pair do |table_name, schema|
      begin

        dynamodb_tables[table_name] = db.tables[table_name].load_schema
        print "table exsits!\n"
      rescue AWS::DynamoDB::Errors::ResourceNotFoundException
        table = db.tables.create(table_name, 10, 5, schema)
        print "Creating table #{table_name}..."
        sleep 1 while table.status == :creating
        print "done!\n"
        dynamodb_tables[table_name] = table.load_schema
      end
    end

    #check if table exists
    print dynamodb_tables[sensor_readings_table_name]


    id =1
    timestamp = 1353446211000
    temp = 290
    increment = 10

    100.times do

      readings = []
      increment = -1 * increment

      5.times do
        readings << {'id' => id.to_s,
                     'timestamp' => timestamp,
                     'temp' => temp.to_s,
                     'acc_x' => '336',
                     'acc_y' => '344',
                     'acc_z' => '1005'}

        id++
        timestamp += 10 * 60 * 1000
        temp += increment
      end

      #Batch write to dynamo db
      dynamodb_tables[sensor_readings_table_name].batch_write(
          :put => readings
      )

      sleep 2
    end

  end


  # populating the relationship data.
  def populate_sqldb

    # populate Device Agent
    [{
         :uri => "1.b19.device-agent.sv.cmu.edu",
         :network_address => "192.168.0.0",
         :print_name => "Bob's Office"
     }].each do |attributes|
      DeviceAgent.create(attributes)
    end
    bob_linux_agent = DeviceAgent.find_by_uri("1.b19.device-agent.sv.cmu.edu")

    # populate Device Types
    [
        {:device_type => "Firefly_v2", :version => "", :manufacturer => "CMU",
        :default_config =>
            "{\"property_type\": [
                \"Temperature\",
                \"Digital Temperature\",
                \"Light\",
                \"Pressure\",
                \"Humidity\",
                \"Motion\",
                \"Audio P2P\",
                \"Accelerometer x\",
                \"Accelerometer y\",
                \"Accelerometer z\"]}" },
        {:device_type => "Electric_Imp", :version => "1", :manufacturer => "Spark Fun",
         :default_config =>
             "{\"property_type\": [
                \"Temperature\",
                \"Digital Temperature\",
                \"Light\",
                \"Pressure\",
                \"Humidity\",
                \"Motion\",
                \"Audio P2P\",
                \"Accelerometer x\",
                \"Accelerometer y\",
                \"Accelerometer z\"]}" }
    ].each do |attributes|
      DeviceType.create(attributes)
    end
    firefly_device_type = DeviceType.find_by_device_type("Firefly_v2")
    electric_imp_device_type = DeviceType.find_by_device_type("Electric_Imp")

    # populate Devices
    [{
         :uri => "1.b19.device.sv.cmu.edu",
         # :device_type_id => firefly_device_type.id,
         :network_address => "192.168.0.0",
         :print_name => "Building 19 - Room 1054"
     },
     {
         :uri => "2.b19.device.sv.cmu.edu",
         # :device_type_id => firefly_device_type.id,
         :network_address => "192.168.1.1",
         :print_name => "Building 19 - Room 1055"
     },
     {
         :uri => "236b404cead3dbee",
         # :device_type_id => firefly_device_type.id,
         :network_address => "192.168.1.2",
         :print_name => "Sumeets Test device",
         :url => "https://agent.electricimp.com/kDj8hNXXSb79",
         :config =>"{\"frequency\": \"2\",\"post_url\": \"http://api.sen.se/events/?sense_key=RMSHIf10oCKD22_NINkGsg\", \"temp_feed_id\": \"38549\" ,\"pressure_feed_id\": \"38550\" , \"motion_feed_id\": \"38551\" , \"humidity_feed_id\": \"38552\" , \"x_acceleration_feed_id\": \"38553\",\"y_acceleration_feed_id\": \"38554\" , \"z_acceleration_feed_id\": \"38555\" , \"light_feed_id\": \"38556\" , \"microphone_feed_id\": \"38557\"}"
     },
     {
         :uri => "2360a83643fc42ee",
         # :device_type_id => firefly_device_type.id,
         :network_address => "192.168.1.2",
         :print_name => "Test device",
         :url => "https://agent.electricimp.com/-Hhrv_1fl3zZ",
         :config =>"{\"frequency\": \"10\",\"post_url\": \"http://api.sen.se/events/?sense_key=RMSHIf10oCKD22_NINkGsg\", \"temp_feed_id\": \"38549\" ,\"pressure_feed_id\": \"38550\" , \"motion_feed_id\": \"38551\" , \"humidity_feed_id\": \"38552\" , \"x_acceleration_feed_id\": \"38553\",\"y_acceleration_feed_id\": \"38554\" , \"z_acceleration_feed_id\": \"38555\" , \"light_feed_id\": \"38556\" , \"microphone_feed_id\": \"38557\"}"
     }].each do |attributes|
      d = Device.create(attributes)
      electric_imp_device_type.devices << d
      bob_linux_agent.devices << d
    end
    firefly_device_1 = Device.find_by_uri("1.b19.device.sv.cmu.edu")
    default_config_json = JSON.parse(firefly_device_type.default_config)
    default_config_json["property_type"].each do |pt|
        st = SensorType.create(:property_type => pt)
        # create one sensor of this sensor-type
        s = Sensor.create({ :uri => "d" || firefly_device_1.id  ||".sensor.b19.sv.cmu.edu", :sensor_type_id => st.id, :device_id => firefly_device_1.id, :frequency => 1 })
        firefly_device_1.sensors << s
    end
  end

  def populate_conversions_table
    Conversion.create(
        :device_type_id => 1,
        :quantity => "temp",
        :description => "Temperature (analog sensor, F)",
        :conversion_type => "linear",
        :a => 0.07506,
        :b => 32,
        :chart_min => 60,
        :chart_max => 80)
  end

end