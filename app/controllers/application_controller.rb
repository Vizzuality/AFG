class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :set_current_guide
  
  protected
  
    def set_current_guide
      @current_guide = Guide.find_or_create_by_session_id(session['session_id'])
    end
  
end
