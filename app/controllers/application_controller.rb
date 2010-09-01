require 'digest/sha1'

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :set_current_guide

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def render_404
    render :file => "public/404.html", :layout => false, :status => 404
  end
  
  protected
  
    def set_current_guide
      session['afg_session_id'] ||= Digest::SHA1.hexdigest(Time.now.to_s + rand(9999).to_s + request.remote_ip.to_s)
      @current_guide = Guide.find_or_create_by_session_id(session['afg_session_id'])
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
      render :file => "public/404.html", :status => 404, :layout => false
    end
  
end
