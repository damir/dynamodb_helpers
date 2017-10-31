require "bundler/setup"
require "aws-sdk-dynamodb"
require "dynamodb_helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# configure local dynamodb
Aws.config.update(endpoint: 'http://localhost:8000', region: 'us-east-1')
CLIENT = Aws::DynamoDB::Client.new

TABLE_NAME = 'dynamodb_helpers_test_table_with_users'

# create temp table
resp = CLIENT.create_table(
  attribute_definitions: [
      {attribute_name: "name", attribute_type: "S"},
      {attribute_name: "email", attribute_type: "S"},
    ],
    key_schema: [
      {attribute_name: "name", key_type: "HASH"},
      {attribute_name: "email", key_type: "RANGE"},
    ],
    provisioned_throughput: {read_capacity_units: 5,write_capacity_units: 5},
    table_name: TABLE_NAME
)

# delete temp table
at_exit do
  CLIENT.delete_table table_name: TABLE_NAME
end

# model to test
class User
  extend DynamodbHelpers

  def self.table_name
    TABLE_NAME
  end
end
