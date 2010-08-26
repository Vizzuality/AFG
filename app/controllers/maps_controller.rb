class MapsController < ApplicationController
  
  skip_before_filter :set_current_guide, :only => [:index, :tiles]
  
  SNAP_TO_GRID_FACTOR = 0.1
    
  def index
  end

  def tiles
    tile = "public/map/"+params[:BBOX]+".png"
    send_file tile, :type=>"image/png", :disposition => 'inline'
  end
  
  def features
    
    occurrences = if params[:species_id]
      if species = Species.find_by_id(params[:species_id])
        Occurrence.select("distinct on (SnapToGrid(the_geom,#{SNAP_TO_GRID_FACTOR})) id, x(ST_Transform(the_geom,3031)) as lon, y(ST_Transform(the_geom,3031)) as lat").where({:species_id => params[:species_id]})
      else
        render :text => "Invalid species_id: #{params[:species_id]}", :status => 404 and return
      end
    elsif params[:landscape_id]
      if landscape = Landscape.find_by_id(params[:landscape_id])
        Occurrence.select("distinct on (SnapToGrid(occurrences.the_geom,#{SNAP_TO_GRID_FACTOR})) occurrences.id, x(ST_Transform(occurrences.the_geom,3031)) as lon, y(ST_Transform(occurrences.the_geom,3031)) as lat").where("st_dwithin(occurrences.the_geom::geography,landscapes.the_geom::geography, radius) AND landscapes.id = #{landscape.id}").from("landscapes, occurrences")
      else
        render :text => "Invalid landscape_id: #{params[:landscape_id]}", :status => 404 and return
      end
    elsif params[:guide_id]
      # FIXME: falta meter también las taxonomías
      if guide = Guide.find_by_id(params[:guide_id])
        Occurrence.select("distinct on (SnapToGrid(occurrences.the_geom,#{SNAP_TO_GRID_FACTOR})) occurrences.id, x(ST_Transform(occurrences.the_geom,3031)) as lon, y(ST_Transform(occurrences.the_geom,3031)) as lat").where("species_id in (select element_id::integer from entries where element_type='Species' and guide_id=#{guide.id})")
      else
        render :text => "Invalid guide_id: #{params[:guide_id]}", :status => 404 and return
      end
    else
      Occurrence.select("distinct on (SnapToGrid(the_geom,#{SNAP_TO_GRID_FACTOR})) id, x(ST_Transform(the_geom,3031)) as lon, y(ST_Transform(the_geom,3031)) as lat")
    end.map{ |o| {:lat => o.lat, :lon => o.lon}}
    
    landscapes = if params[:species_id]
      if species = Species.find_by_id(params[:species_id])
        Landscape.select("distinct(landscapes.id), landscapes.name, landscapes.permalink, landscapes.description, landscapes.guides_count, x(ST_Transform(landscapes.the_geom,3031)) as lon, y(ST_Transform(landscapes.the_geom,3031)) as lat").from("occurrences, landscapes").where("st_dwithin(occurrences.the_geom::geography,landscapes.the_geom::geography, landscapes.radius) AND occurrences.species_id=#{species.id}")
      else
        render :text => "Invalid species_id: #{params[:species_id]}", :status => 404 and return
      end
    elsif params[:landscape_id]
      if landscape = Landscape.find_by_id(params[:landscape_id])
        Landscape.select("landscapes.id, name, permalink, description, guides_count, x(ST_Transform(landscapes.the_geom,3031)) as lon, y(ST_Transform(landscapes.the_geom,3031)) as lat").from("landscapes").where(:id => landscape.id)
      else
        render :text => "Invalid landscape_id: #{params[:landscape_id]}", :status => 404 and return
      end
    elsif params[:guide_id]
      if guide = Guide.find_by_id(params[:guide_id])
        Landscape.select("landscapes.id, name, permalink, description, guides_count, x(ST_Transform(landscapes.the_geom,3031)) as lon, y(ST_Transform(landscapes.the_geom,3031)) as lat").from("landscapes").where("landscapes.id IN (select element_id::integer from entries where element_type='Landscape' and guide_id=#{guide.id})")
      else
        render :text => "Invalid guide_id: #{params[:guide_id]}", :status => 404 and return
      end
    else
      Landscape.select("distinct(landscapes.id), landscapes.name, landscapes.permalink, landscapes.description, landscapes.guides_count, x(ST_Transform(landscapes.the_geom,3031)) as lon, y(ST_Transform(landscapes.the_geom,3031)) as lat")
    end.map do |l| 
      {
        :url => landscape_url(l), 
        :add_url => (@current_guide.include_landscape?(l) ? nil : entries_url(:type => 'Landscape', :id => l.id)),
        :name => l.name,
        :description => l.description,
        :guides_count => l.guides_count,
        :picture => l.picture? ? l.picture.image.url(:small) : nil,
        :lat => l.lat,
        :lon => l.lon
      }
    end
        
    respond_to do |format|
      format.json do
        render :json => { :occurrences => occurrences, :landscapes => landscapes }.to_json
      end
    end
  end

end
