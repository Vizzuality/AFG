class Api::ImagesController < ApplicationController
  
  def show
    if params[:species_id]
      species = Species.find_by_id(params[:species_id])
      render :text => "Species not found with id #{params[:species_id]}" and return unless species
      picture = species.pictures.find_by_id(params[:image_id])
      render :text => "Picture not found with id #{params[:image_id]}" and return unless picture
      pictures = ([picture] + (species.pictures - [picture]))
    elsif params[:landscape_id]
      landscape = Landscape.find_by_id(params[:landscape_id])
      render :text => "Lanscape not found with id #{params[:landscape_id]}" and return unless landscape
      picture = landscape.pictures.find_by_id(params[:image_id])
      render :text => "Picture not found with id #{params[:image_id]}" and return unless picture      
      pictures = ([picture] + (landscape.pictures - [picture]))
    end
    pictures.map do |picture|
      {
        :id => picture.id,
        :url => picture.image.url(:huge),
        :description => picture.description
      }
    end
    
    respond_to do |format|
      format.json do 
        render :json => pictures.to_json
      end
    end
  end
  
end