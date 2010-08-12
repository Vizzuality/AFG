class SpeciesController < ApplicationController
  
  def index
    
  end
  
  def show
    @species = Species.complete.find(params[:id])
  end
  
end