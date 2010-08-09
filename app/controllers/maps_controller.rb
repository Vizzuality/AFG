class MapsController < ApplicationController
  def index
    
  end

  def tiles
    
    tile= "public/map/"+params[:BBOX]+".png"
    send_file tile, :type=>"image/png", :disposition => 'inline'
    
    #respond_to do |format|
    #  format.html  { render :json => files.to_json }
    #end    
    
  end

end
