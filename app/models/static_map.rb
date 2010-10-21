require 'rvg/rvg'

class StaticMap

  IMAGE_FORMAT = 'png'
  SNAP_TO_GRID_FACTOR = 0.1

  def self.generate_typed_map(type, element_id)
    if type == :species
      coords=Array.new
      Occurrence.select("distinct on (SnapToGrid(the_geom,#{SNAP_TO_GRID_FACTOR})) id,
        x(ST_Transform(the_geom,3031)) as lon,
        y(ST_Transform(the_geom,3031)) as lat").where("#{type}_id = '#{element_id}'").each { |occ|
        coords << occ.lon+","+occ.lat
      }
      img = create_static_map(coords.join("|"))
      img.to_blob
    elsif type == :landscapes
      l = Landscape.select("x(ST_Transform(the_geom,3031)) as lon,y(ST_Transform(the_geom,3031)) as lat").where("id = '#{element_id}'")
      img = create_static_map(l.first.lon + "," + l.first.lat,"red",6)
      img.to_blob
    end
  end

  def self.create_static_map(coords,color="red",marker_size=3)
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
    img.format = IMAGE_FORMAT
    return img
  end

end