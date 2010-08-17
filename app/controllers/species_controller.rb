class SpeciesController < ApplicationController
  
  def index
    @featured_species = Species.featured.first
    @species = Species.complete.not_featured.limit(6).order("guides_count DESC")
  end
  
  def show
    @species = Species.find(params[:id])
  end
  
end
