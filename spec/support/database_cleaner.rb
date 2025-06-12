RSpec.configure do |config|
  # Clean the test database before each test
  config.before(:each) do
    Task.destroy_all
  end
end