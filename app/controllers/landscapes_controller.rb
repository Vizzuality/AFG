class LandscapesController < ApplicationController
  
  def index  
  end
  
  def show
    @landscape = Landscape.find(params[:id])
  end
  
end
