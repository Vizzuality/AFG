class GuidesController < ApplicationController
  
  before_filter :set_current_date_filter, :only => [:index]
  
  before_filter :validate_id_param, :only => [:show]
  
  def index
    guides = Guide.published.not_highlighted
    
    # sort_by filter
    guides = if params[:sort_by].nil? || params[:sort_by] == 'popularity'
      guides.sort_by_popularity
    else
      guides.sort_by_most_recent
    end
    
    # range of dates filter
    guides = case params[:date]
      when nil, 'week'
        guides.where(["created_at > ?", 1.week.ago])
      when 'month'
        guides.where(["created_at > ?", 1.month.ago])
      when 'months3'
        guides.where(["created_at > ?", 3.month.ago])
      when 'year'
        guides.where(["created_at > ?", 1.year.ago])
    end
    
    @guides = guides.paginate(:per_page => 9, :page => params[:page])
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @guide = Guide.find(params[:id])
    validate_permalink(@guide)
  end
  
  def pdf
    @guide = Guide.find_by_permalink(params[:permalink]) || Guide.find(params[:permalink])
    @guide.increment(:downloads_count)
    @guide.save
    # Current page number
    @count = 2
    @total_pages = if params[:checklist]
      @guide.pages_count(:checklist)
    else
      @guide.pages_count(:complete)
    end

    render :template => 'guides/show_pdf', :layout => false
  end
  
  def update
    if params[:reset]
      session[:current_guide_print] = {}
    end
    
    session[:current_guide_print] ||= {}
    
    if params[:guide_format]
      session[:current_guide_print][:guide_format] = (params[:guide_format] == 'checklist') ? 'checklist' : 'complete'
    end
    if params[:name]
      session[:current_guide_print][:name] = params[:name]
    end
    if params[:author]
      session[:current_guide_print][:author] = params[:author]
    end
    if params[:publish]
      session[:current_guide_print][:publish] = params[:publish] == 'true' ? true : false
    end
    if params[:description]
      session[:current_guide_print][:description] = params[:description]
    end

    if params[:print] && params[:print] == 'true'
      new_attributes = {}
      new_attributes.merge!(:name => session[:current_guide_print][:name]) if session[:current_guide_print][:name]
      new_attributes.merge!(:author => session[:current_guide_print][:author]) if session[:current_guide_print][:author]
      new_attributes.merge!(:description => session[:current_guide_print][:description]) if session[:current_guide_print][:description]
      new_attributes.merge!(:published => session[:current_guide_print][:publish]) if session[:current_guide_print][:publish]

      @current_guide.attributes = new_attributes
      @current_guide.save
      
      if @current_guide.published?
        @current_guide.update_attribute(:session_id, nil)
      end
      
      request_full_path = if Rails.env.development?
        "http://localhost:3001#{request.fullpath}"
      else
        "http://#{request.host_with_port}#{request.fullpath}"
      end
      
      pdf_path = @current_guide.generate_pdf!(request_full_path, session[:current_guide_print][:guide_format] && (session[:current_guide_print][:guide_format] == 'checklist') ? true : nil )
      
      render :text => {:href => pdf_path, :url => guide_path(@current_guide)}.to_json, :status => 200 and return
    end
        
    respond_to do |format|
      format.js do
        render :text => '', :status => 200
      end
    end
  end
  
  def undo
    @current_guide.undo_last_action
    flash[:notice] = "Undo performed successfully"
    respond_to do |format|
      format.html do
        redirect_to :back
      end
    end
  end
  
  protected
  
    def set_current_date_filter
      @current_date_filter = (params[:date].blank? || !date_filters.keys.include?(params[:date].to_sym)) ? :week : params[:date].to_sym
    end
    
    def date_filters 
      @date_filters ||= ActiveSupport::OrderedHash[
        :week, 'From last week',
        :month, 'From last month',
        :months3, 'From last 3 months',
        :year,'From last year'
      ]
      @date_filters
    end
    helper_method :date_filters
        
end