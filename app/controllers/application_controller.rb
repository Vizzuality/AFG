class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :set_current_guide
  
  protected
  
    def set_current_guide
      @current_guide = Guide.find_or_create_by_session_id(session['session_id'])
    end
    
    # Name: afg
    # Password: by default 'afg'. This should be changed      
    def admin_authenticated
      authenticate_or_request_with_http_digest("Application") do |name|
        if name == 'afg'
          AdminPassword.count == 0 ? 'afg' : AdminPassword.first.password
        else
          nil
        end
      end
    end
  
end
