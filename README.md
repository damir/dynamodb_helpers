# DynamoDB helpers

Currently only the scan finder is implemented. It will issue multiple scans for each 1MB and combine them into a single result.
Dataset returned is a plain ruby hash which gives you significant speed-up over aws-record gem if you are only interested in reading the data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamodb_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamodb_helpers

## Usage


```ruby
# Instantiate the client which will require table_name option on each call
DynamoClient = Class.new.extend(DynamodbHelpers)

# or extend your class and provide table_name method
class User
  extend DynamodbHelpers

  def self.table_name
    'users'
  end
end

# Find by multiple keys:
User.scan_and_find_by(name: 'Joe', email: 'joe@example.com')
# => [{"name"  => "Joe", "email" => "joe@example.com", ... other attributes}, ...]

# Return specific fields:
User.scan_and_find_by({name: 'Joe', email: 'joe@example.com'}, select: [:email])
# => [{"email" => "joe@example.com"}, ...]

# Find by scanning in parallel with multiple threads:
User.scan_and_find_by({name: 'Joe'}, segments: 5)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/damir/dynamodb_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DynamodbHelpers project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/damir/dynamodb_helpers/blob/master/CODE_OF_CONDUCT.md).
