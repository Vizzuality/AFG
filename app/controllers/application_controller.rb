class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :set_current_guide, :except => [:tiles]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def render_404
    render :file => "public/404.html", :template => false, :status => 404
  end
  
  protected
  
    def set_current_guide
      @current_guide = Guide.find_or_create_by_session_id(session['session_id'])
      @entries = @current_guide.entries.paginate :page => params[:entry_page], :per_page => 5
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
    
    def validate_id_param
      if params[:id] =~ /\A\d+\-([a-z0-9\-]+)\z/
        @permalink = $1
      else
        render_404 and return false
      end
    end
    
    def validate_permalink(object)
      render_404 and return false unless object.permalink == @permalink
    end
    
    def record_not_found
      render :file => "public/404.html", :status => 404
    end
  
end
