module HelperMethods
  # Put helper methods you need to be available in all tests here.
  def peich
    save_and_open_page
  end

  def enable_javascript
    Capybara.current_driver = :selenium
  end

  def create_pdf_session
    Capybara.server_port = 3001
    Capybara::Server.new(AFG::Application).boot

    # thread = Thread.new do
      # require 'rack/handler/webrick'
      # Rack::Handler::WEBrick.run(AFG::Application, :Port => 3001)
    # end
    # thread.join

  end

  def pdf_should_exists(pdf_uri)
    url = URI.parse("http://localhost:3001")
    Net::HTTP.start(url.host, url.port) { |http|
      http.head(url.request_uri).code.should == '200'
    }
  end
end

RSpec.configuration.include(HelperMethods)
RSpec.configuration.include(ActionView::Helpers::TextHelper)
