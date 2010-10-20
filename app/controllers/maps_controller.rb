class MapsController < ApplicationController

  include ActionView::Helpers::TextHelper

  skip_before_filter :set_current_guide, :only => [:static_map,:tiles]

  def index
  end

  def tiles
    tile = "public/map/base_tiles/"+params[:BBOX]+".#{StaticMap::IMAGE_FORMAT}"
    send_file tile, :type=>"image/#{StaticMap::IMAGE_FORMAT}", :disposition => 'inline'
  end

  def static_map
    #If the map is asked by speciesId take the data from DB
    if params[:species_id]
      maps_cache_fetch(:species, params[:species_id]) do
        StaticMap.generate_typed_map(:species, params[:species_id])
      end

    #if Lanscape ID is being sent
    elsif params[:landscape_id]
      maps_cache_fetch(:landscapes, params[:landscape_id]) do
        StaticMap.generate_typed_map(:landscapes, params[:landscape_id])
      end

    #If the map is asked by coords just draw
    elsif params[:coords]
      img = StaticMap.create_static_map(params[:coords])
      send_data img.to_blob,:type => "image/#{StaticMap::IMAGE_FORMAT}",:disposition => 'inline',:filename => "static.#{StaticMap::IMAGE_FORMAT}"

    #if nothing is being sent just send the background.
    else
      send_file "#{Rails.root}/public/images/pdf/map_bkg.jpg", :type=>"image/#{StaticMap::IMAGE_FORMAT}", :disposition => 'inline'
    end
  end

  def features

    occurrences = if params[:species_id]
      if species = Species.find_by_id(params[:species_id])
        Occurrence.select("distinct on (SnapToGrid(the_geom,#{StaticMap::SNAP_TO_GRID_FACTOR})) id, x(ST_Transform(the_geom,3031)) as lon, y(ST_Transform(the_geom,3031)) as lat").where({:species_id => params[:species_id]})
      else
        render :text => "Invalid species_id: #{params[:species_id]}", :status => 404 and return
      end
    elsif params[:landscape_id]
      if landscape = Landscape.find_by_id(params[:landscape_id])
        Occurrence.select("distinct on (SnapToGrid(occurrences.the_geom,#{StaticMap::SNAP_TO_GRID_FACTOR})) occurrences.id, x(ST_Transform(occurrences.the_geom,3031)) as lon, y(ST_Transform(occurrences.the_geom,3031)) as lat").where("st_dwithin(occurrences.the_geom::geography,landscapes.the_geom::geography, radius) AND landscapes.id = #{landscape.id}").from("landscapes, occurrences")
      else
        render :text => "Invalid landscape_id: #{params[:landscape_id]}", :status => 404 and return
      end
    elsif params[:guide_id]
      # FIXME: falta meter también las taxonomías
      if guide = Guide.find_by_id(params[:guide_id])
        Occurrence.select("distinct on (SnapToGrid(occurrences.the_geom,#{StaticMap::SNAP_TO_GRID_FACTOR})) occurrences.id, x(ST_Transform(occurrences.the_geom,3031)) as lon, y(ST_Transform(occurrences.the_geom,3031)) as lat").where("species_id in (select element_id::integer from entries where element_type='Species' and guide_id=#{guide.id})")
      else
        render :text => "Invalid guide_id: #{params[:guide_id]}", :status => 404 and return
      end
    else
      Occurrence.select("distinct on (SnapToGrid(the_geom,#{StaticMap::SNAP_TO_GRID_FACTOR})) id, x(ST_Transform(the_geom,3031)) as lon, y(ST_Transform(the_geom,3031)) as lat")
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
        :add_url => (@current_guide.include_landscape?(l) ? nil : create_entry_url(:type => 'Landscape', :id => l.id)),
        :name => l.name,
        :description => truncate(l.description, :length=> 170),
        :guides_count => l.guides_count,
        :picture => l.picture? ? l.picture.image.url(:small) : nil,
        :picture_large => l.picture? ? l.picture.image.url(:large) : nil,
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

  private

    def maps_cache_fetch(type, id, options = {})
      if !options[:force] and value = get(type, id)
        Rails.logger.info "[AFG] cache hit #{type} #{id}"
        send_data value,:type => "image/#{StaticMap::IMAGE_FORMAT}",:disposition => 'inline',:filename => "static.#{StaticMap::IMAGE_FORMAT}"
      elsif block_given?
        Rails.logger.info "[AFG] cache miss #{type} #{id}"
        value = yield
        set(type, id, value)
        Rails.logger.info "[AFG] cache stored #{type} #{id}"
        send_data value,:type => "image/#{StaticMap::IMAGE_FORMAT}",:disposition => 'inline',:filename => "static.#{StaticMap::IMAGE_FORMAT}"
      end
    end

    def get(type, id)
      type.to_s.classify.constantize.maps_cache_get(id)
    end

    def set(type, id, value)
      type.to_s.classify.constantize.maps_cache_set(id, value)
    end

end