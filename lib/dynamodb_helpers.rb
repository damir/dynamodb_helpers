require "dynamodb_helpers/version"

module DynamodbHelpers
  def scan_and_find_by(query_opts, opts = {segments: false, select: false, table_name: false})

    query = {table_name: opts[:table_name] ? opts[:table_name] : self.table_name, select: 'ALL_ATTRIBUTES', scan_filter: {}}

    query_opts.each do | key, value |
      if value.nil?
        # raise "Detected nil value for #{key}"
        return []
      else
        query[:scan_filter].merge!(key.to_s => {:comparison_operator => "EQ", :attribute_value_list => [value]})
      end
    end

    if query[:scan_filter].length >= 2
      query.merge!(:conditional_operator => "AND")
    end

    # field selection
    query.merge!(select: "SPECIFIC_ATTRIBUTES", attributes_to_get: opts[:select]) if opts[:select]

    return scan_in_parallel(query, opts) if opts[:segments]
    return scan_sequentialy(query)
  end

  private

  def scan_sequentialy(query)
    client =  ::Aws::DynamoDB::Client.new

    # first query
    result = client.scan(query)
    items = result.items

    # extra queries if data > 1 MB
    while result.last_evaluated_key
      result = client.scan(query.merge(exclusive_start_key: result.last_evaluated_key))
      items = items + result.items
    end

    items
  end

  def scan_in_parallel(query, opts)
    segments = Integer(opts[:segments])
    items = [] # no need for mutex, we are just appending to this. ordering is not guaranteed !!!

    # do sequential scan for each segment
    segments.times do |n|
      Thread.new{items = items + scan_sequentialy(query.merge(segment: n, total_segments: segments))}.join
    end

    items
  end
end
