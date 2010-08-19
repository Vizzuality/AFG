class AddTheGeomToLandscapes < ActiveRecord::Migration
  def self.up
    add_column :landscapes, :the_geom, :multi_polygon, :srid => 4326, :null => false
  end

  def self.down
    remove_column :landscapes, :multi_polygon
  end
end
