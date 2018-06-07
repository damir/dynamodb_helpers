RSpec.describe DynamodbHelpers do
  USER_ATTRS = {"name"  => "Joe", "email" => "joe@example.com"}

  it "has a version number" do
    expect(DynamodbHelpers::VERSION).not_to be nil
  end

  it "finds user by name by extending class" do
    CLIENT.put_item(item: USER_ATTRS, table_name: TABLE_NAME)
    expect(User.scan_and_find_by(name: USER_ATTRS['name'])).to eq([USER_ATTRS])
  end

  it "finds user by name passing table_name option" do
    DynamoClient = Class.new.extend(DynamodbHelpers)
    expect(DynamoClient.scan_and_find_by({name: USER_ATTRS['name']}, table_name: TABLE_NAME)).to eq([USER_ATTRS])
  end

  it "finds user by name and email" do
    CLIENT.put_item(item: USER_ATTRS, table_name: TABLE_NAME)
    expect(User.scan_and_find_by(name: USER_ATTRS['name'], email: USER_ATTRS['email'])).to eq([USER_ATTRS])
  end

  it "finds users by email" do
    10.times{|n| CLIENT.put_item(item: USER_ATTRS.merge({"name"  => "Joe#{n}"}), table_name: TABLE_NAME)}
    expect(User.scan_and_find_by(email: USER_ATTRS['email']).size).to eq(11)
  end

  it "finds users by email" do
    10.times{|n| CLIENT.put_item(item: USER_ATTRS.merge({"name"  => "Joe#{n}"}), table_name: TABLE_NAME)}
    expect(User.scan_and_find_by(email: USER_ATTRS['email']).size).to eq(11)
  end

  it "return specific attributes" do
    user = User.scan_and_find_by({email: USER_ATTRS['email']}, select: [:email]).first
    expect(user.keys).to eq(['email'])
  end

  it "finds users by email with pagination" do
    1000.times{|n| CLIENT.put_item(item: USER_ATTRS.merge({"name"  => "Joe#{n}" * 250}), table_name: TABLE_NAME)}
    expect(User.scan_and_find_by(email: USER_ATTRS['email']).size).to eq(1011)
  end

  it "finds users by email with pagination when scanning in parallel" do
    expect(User.scan_and_find_by({email: USER_ATTRS['email']}, segments: 5).size).to eq(1011)
  end
end
