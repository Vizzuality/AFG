require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'
require "capybara/dsl"
require 'database_cleaner'
# require "selenium-webdriver"

DatabaseCleaner.strategy = :transaction
Capybara.default_driver = :rack_test
Capybara.default_host = 'www.example.com'
Capybara.app_host = 'http://www.example.com:9887'
Capybara.default_wait_time = 5

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include Capybara
  
  config.before(:each) do
    Rails.cache.clear
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  config.after(:each) do
    case page.driver.class
    when Capybara::Driver::RackTest
      page.driver.rack_mock_session.clear_cookies
    when Capybara::Driver::Culerity
      page.driver.browser.clear_cookies
    when Capybara::Driver::Selenium
      page.driver.cleanup!
    end
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
  
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
