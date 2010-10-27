module HelperMethods
  # Put helper methods you need to be available in all tests here.
  def peich
    save_and_open_page
  end

  def enable_javascript
    Capybara.current_driver = :selenium
  end
end

RSpec.configuration.include(HelperMethods)
