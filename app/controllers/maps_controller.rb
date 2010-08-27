class MapsController < ApplicationController
  
  skip_before_filter :set_current_guide, :only => [:static_map,:tiles,:create_static_map]
  
  SNAP_TO_GRID_FACTOR = 0.1
    
  def index
  end

  def tiles
    tile = "public/map/base_tiles/"+params[:BBOX]+".png"
    send_file tile, :type=>'image/png', :disposition => 'inline'
  end
  
  def static_map
    
    #If the map is asked by speciesId take the data from DB
    if params[:species_id] 
      coords=Array.new
      Occurrence.select("distinct on (SnapToGrid(the_geom,#{SNAP_TO_GRID_FACTOR})) id, 
        x(ST_Transform(the_geom,3031)) as lon, 
        y(ST_Transform(the_geom,3031)) as lat").where({:species_id => params[:species_id]}).each { |occ|
        coords << occ.lon+","+occ.lat
      }
      img = create_static_map(coords.join("|"))
      send_data img.to_blob,:type => 'image/png',:disposition => 'inline',:filename => "static.png"
    
    #if Lanscape ID is being sent
    elsif params[:landscape_id]
      l = Landscape.select("x(ST_Transform(the_geom,3031)) as lon,y(ST_Transform(the_geom,3031)) as lat").where({:id => params[:landscape_id]})
      img = create_static_map(l.first.lon + "," + l.first.lat,"red",6)
      send_data img.to_blob,:type => 'image/png',:disposition => 'inline',:filename => "static.png"
    
    #If the map is asked by coords just draw  
    elsif params[:coords]
      img = create_static_map(params[:coords])
      send_data img.to_blob,:type => 'image/png',:disposition => 'inline',:filename => "static.png"
      
    #if nothing is being sent just send the background.
    else
      send_file "#{Rails.root}/public/images/pdf/map_bkg.jpg", :type=>'image/png', :disposition => 'inline'
    end
  end
  
  def create_static_map(coords,color="red",marker_size=3)
    rvg = Magick::RVG.new(390, 315) do |canvas|
      canvas.background_fill = 'white'
      bkg = ::Magick::Image.read("#{Rails.root}/public/images/pdf/map_bkg.jpg").first
      canvas.image(bkg, 390, 315, 0, 0).preserve_aspect_ratio('none')
      
      #calculations for the positions
      #extends of the map
      map_bottom = -4031207.0230865
      map_left= -4426580.3634536
      map_right= 5458882.5229527
      map_top= 3953205.3082417
      widthspan = 9885462.89
      heightspan = 7984412.33
      
      image_map_width=395
      image_map_height=315    
      
      #Draw the points. We could be using: http://studio.imagemagick.org/RMagick/doc/rvgstyle.html
      canvas.g.styles(:fill=>color) do |g|       
        coords.split("|").each { |pair|
          lon = pair.split(",")[0]
          lat = pair.split(",")[1]
          
          widthposspan= map_left.abs+lon.to_f
          xoffset = (widthposspan*image_map_width)/widthspan
          
          heightposspan= map_bottom.abs+lat.to_f
          yoffset = image_map_height - ((heightposspan*image_map_height)/heightspan)

          if (xoffset>=0 and xoffset<=image_map_width and yoffset>=0 and yoffset<=image_map_height)
            g.circle(marker_size, xoffset,yoffset)
          end          

        }
      end
    end
    img = rvg.draw
    img.format = "png"
    return img
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
        :add_url => (@current_guide.include_landscape?(l) ? nil : create_entry_url(:type => 'Landscape', :id => l.id)),
        :name => l.name,
        :description => l.description,
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

end
