class SpeciesController < ApplicationController
  
  def index
    @featured_species = Species.featured.first
  end
  
  def show
    @species = Species.find(params[:id])
  end
  
end
