class GuidesController < ApplicationController
  
  before_filter :set_current_date_filter, :only => [:index]
  
  def index
    guides = Guide.published.not_highlighted
    guides = if params[:sort_by].nil? || params[:sort_by] == 'popularity'
      guides.sort_by_popularity
    else
      guides.sort_by_most_recent
    end
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
  end

  def show
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
