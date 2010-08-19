class LandscapesController < ApplicationController
  
  before_filter :validate_id_param, :only => [:show]
  
  def index 
    @featured_landscape = Landscape.featured.first
    @landscapes = Landscape.not_featured.limit(6).order("guides_count DESC")
  end
  
  def show
    @landscape = Landscape.find(params[:id])
    validate_permalink(@landscape)
  end
  
end
