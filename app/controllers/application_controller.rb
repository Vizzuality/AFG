class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :set_current_guide
  
  protected
  
    def set_current_guide
      @current_guide = Guide.find_by_session_id(session['session_id']) || Guide.create(:session_id => session['session_id'])
    end
  
end
