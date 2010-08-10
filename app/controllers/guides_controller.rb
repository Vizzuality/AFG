class GuidesController < ApplicationController
  
  # include PdfHelper
  
  before_filter :set_current_date_filter, :only => [:index]
  
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
  end
  
  def pdf
    @guide = Guide.find(params[:id])
    send_file(
      make_pdf('guides/show_pdf', @guide.pdf_name),
      :filename => @guide.pdf_name,
      :disposition => 'inline',
      :type => 'application/pdf'
    ) 
    
  end
  
  def edit
    @guide = @current_guide
    @guide.publish!
  end
  
  def update
    @guide = @current_guide
    if @guide.update_attributes(params[:guide])
      flash[:notice] = 'Guide published'
      # TODO: habria que redirigir a download PDF
      redirect_to guide_path(@guide.id)
    else
      render :action => 'edit'
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
    
  private
  
    def make_pdf(template_path, pdf_name, landscape=false)
      prince = Prince.new
      # Sets style sheets on PDF renderer.
      prince.add_style_sheets(
        "public/stylesheets/pdf.css"
      )
      # Render the estimate to a big html string.
      # Set RAILS_ASSET_ID to blank string or rails appends some time after
      # to prevent file caching, fucking up local - disk requests.
      ENV["RAILS_ASSET_ID"] = ''
      html_string = render_to_string(:template => template_path, :layout => 'application')
      # Make all paths relative, on disk paths...
      html_string.gsub!("src=\"", "src=\"public")
      # Send the generated PDF file from our html string.
      return prince.pdf_from_string(html_string)
    end
  
    
end