require 'capybara/rails'
require 'capybara/rspec'

# Configure Capybara
Capybara.default_host = 'http://localhost'
Capybara.app_host = 'http://localhost:3000'
Capybara.server_host = 'localhost'
Capybara.server_port = 3000

# Configure the test server to use localhost
Capybara.server = :puma, { Silent: true }

# Allow localhost connections in system tests
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end