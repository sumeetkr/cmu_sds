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

  desc "Fill database with sample data"
  task :populate => [:environment] do
    #Call methods to populate db
    #populate_dynamodb
    puts "Finished populating the database."
  end

  desc "re-populate the database with sample data"
  task :repopulate => [:migrate_all, :empty, :populate] do
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

    readings = []
    id = 2
    timestamp = 1353446211000
    temp = 290

    25.times do

      readings << {'id' => id.to_s,
                   'timestamp' => timestamp,
                   'temp' => temp.to_s,
                   'acc_x' => '336',
                   'acc_y' => '344',
                   'acc_z' => '1005'}

      id++
      timestamp += 60 * 1000
      temp += 10
    end

    #Batch write to dynamo db
    dynamodb_tables[sensor_readings_table_name].batch_write(
        :put => readings
    )

  end
end