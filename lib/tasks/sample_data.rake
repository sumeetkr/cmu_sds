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

    sensor_readings_table_name = "SensorReadingV3"

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


    id =3
    timestamp = 1353446211000
    temp = 290
    increment = 10

    1000.times do

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
        {:device_type => "Firefly_v2", :version => "", :manufacturer => "CMU"}
    ].each do |attributes|
      DeviceType.create(attributes)
    end
    firefly_device_type = DeviceType.find_by_device_type("Firefly_v2")


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
     }].each do |attributes|
      d = Device.create(attributes)
      firefly_device_type.devices << d
      bob_linux_agent.devices << d
    end
    firefly_device_1 = Device.find_by_uri("1.b19.device.sv.cmu.edu")

    # populate Sensor Types
    [{:property_type => "Temperature"},
     {:property_type => "Digital Temperature"},
     {:property_type => "Light"},
     {:property_type => "Pressure"},
     {:property_type => "Humidity"},
     {:property_type => "Motion"},
     {:property_type => "Audio P2P"},
     {:property_type => "Accelerometer x"},
     {:property_type => "Accelerometer y"},
     {:property_type => "Accelerometer z"}
    ].each do |attributes|
      SensorType.create(attributes)
    end
    temperature_sensor_type = SensorType.find_by_property_type("Temperature")

    # populate Sensors
    [{
         :uri => "1.sensor.b19.sv.cmu.edu",
         :sensor_type_id => temperature_sensor_type.id,
         :device_id => firefly_device_1.id,
         :min_value => "",
         :max_value => ""
              },
     {
         :uri => "2.sensor.b19.sv.cmu.edu",
         :sensor_type_id => temperature_sensor_type.id,
         :device_id => firefly_device_1.id,
         :min_value => "",
         :max_value => ""
              },
     {
         :uri => "3.sensor.b19.sv.cmu.edu",
         :sensor_type_id => temperature_sensor_type.id,
         :device_id => firefly_device_1.id,
         :min_value => "",
         :max_value => ""
              },
     {
         :uri => "4.sensor.b19.sv.cmu.edu",
         :sensor_type_id => temperature_sensor_type.id,
         :device_id => firefly_device_1.id,
         :min_value => "",
         :max_value => "",
             },
     {
         :uri => "5.sensor.b19.sv.cmu.edu",
         :sensor_type_id => temperature_sensor_type.id,
         :device_id => firefly_device_1.id,
         :min_value => "",
         :max_value => "",
             }].each do |attributes|
      s = Sensor.create(attributes)
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