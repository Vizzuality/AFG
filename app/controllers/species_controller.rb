class SpeciesController < ApplicationController
  
  def index
    
  end
  
  def show
    @species = Species.find(params[:id])
  end
  
end
