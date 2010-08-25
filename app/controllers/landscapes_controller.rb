class LandscapesController < ApplicationController
  
  before_filter :validate_id_param, :only => [:show]
  
  def index 
    respond_to do |format|
      format.html do
        @featured_landscape = Landscape.featured.first
        @landscapes = Landscape.not_featured.limit(6).order("guides_count DESC")
      end
    end
  end
  
  def show
    @landscape = Landscape.find(params[:id])
    validate_permalink(@landscape)
  end
  
end
