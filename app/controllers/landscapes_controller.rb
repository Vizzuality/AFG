class LandscapesController < ApplicationController
  
  before_filter :validate_id_param, :only => [:show]
  
  def index 
    respond_to do |format|
      format.html do
        @featured_landscape = Landscape.featured.first
        @landscapes = Landscape.not_featured.limit(6).order("guides_count DESC")
      end
      format.json do
        render :json => Landscape.all.map do |l| 
          l.to_json.merge({
            :url => landscape_url(l), 
            :added => (@current_guide.include_landscape?(l) ? true : nil)
          })
        end.to_json
      end
    end
  end
  
  def show
    @landscape = Landscape.find(params[:id])
    validate_permalink(@landscape)
  end
  
end
