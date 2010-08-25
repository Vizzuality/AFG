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
    @guide = Guide.find(params[:id])
    @guide.increment(:downloads_count)
    @guide.save
    @species = Species.limit(20)
    render :template => 'guides/show_pdf', :layout => false
  end
  
  def edit
    @guide = @current_guide
    @guide.publish!
  end
  
  def update
    @guide = @current_guide
    @guide.attributes = params[:guide]
    if @guide.save
      flash[:notice] = 'Guide published'
      # TODO: habria que redirigir a download PDF
      redirect_to guide_path(@guide.id)
    else
      render :action => 'edit'
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