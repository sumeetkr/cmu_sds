require "aws"
AWS.config(
    access_key_id: "AKIAIPTXJSGSYF2M6WUQ",
    secret_access_key: "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"
)

# create a table (10 read and 5 write capacity units) with the
# default schema (id string hash key)
DB = AWS::DynamoDB.new
TABLES = {}

sensor_readings_table_name = "SensorReadingV3"

{
    sensor_readings_table_name => {
        hash_key: {id: :string},
        range_key: {timestamp: :string}
    }
}.each_pair do |table_name, schema|
  begin
    TABLES[table_name] = DB.tables[table_name].load_schema
  rescue AWS::DynamoDB::Errors::ResourceNotFoundException
    table = DB.tables.create(table_name, 10, 5, schema)
    print "Creating table #{table_name}..."
    sleep 1 while table.status == :creating
    print "done!\n"
    TABLES[table_name] = table.load_schema
  end
end

#check if table exists
print TABLES[sensor_readings_table_name]

sample_json=
    '{
        "acc_z" : 1005,
    "bat" : 1005,
    "gpio_state" : 1,
    "temp" : 510,
    "light" : 889,
    "__class__" : "Env_Data",
    "humidity" : 23,
    "motion" : 1005,
    "pressure" : 101740,
    "__module__" : "pyfly",
    "digital_temp" : 241,
    "audio_p2p" : 1,
    "timestamp" : 1353441771000,
    "id" : "1",
    "acc_y" : 344,
    "acc_x" : 336
}'


# add an individual item
item = TABLES[sensor_readings_table_name].items.create('id' => '12345',
                                                       'timestamp' => 1353441771000,
                                                       'temp' => '510',
                                                       'acc_x' => '336',
                                                       'acc_y' => '344',
                                                       'acc_z' => '1005'
)


#Batch write to dynamo db
TABLES[sensor_readings_table_name].batch_write(
    :put => [
        {'id' => '12351',
         'timestamp' => 1353441771000,
         'temp' => '510'},
        {'id' => '12352',
         'timestamp' => 1353441771000,
         'temp' => '510'}
    ]
)


# add attributes to an item
item.attributes.add 'category' => %w(demo), 'tags' => %w(sample item)

#shows the attributes of the item
#TABLES[sensor_readings_table_name].items.each { |i| puts i.attributes.to_h }