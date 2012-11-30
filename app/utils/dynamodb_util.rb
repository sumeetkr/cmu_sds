require "aws"
AWS.config(
    access_key_id: "AKIAIPTXJSGSYF2M6WUQ",
    secret_access_key: "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"
)

# create a table (10 read and 5 write capacity units) with the
# default schema (id string hash key)
DB = AWS::DynamoDB.new
TABLES = {}

sensor_readings_table_name = "SensorReadingV2"
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

# add an item
item = TABLES["sensor_readings_table_name"].items.create('id' => '12333', 'foo' => 'bar')
# add attributes to an item
item.attributes.add 'category' => %w(demo), 'tags' => %w(sample item)

TABLES[sensor_readings_table_name].items.each{|i| puts i.attributes.to_h }