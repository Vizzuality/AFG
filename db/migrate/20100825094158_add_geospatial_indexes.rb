class AddGeospatialIndexes < ActiveRecord::Migration
  def self.up
    add_index :occurrences, :the_geom, :spatial => true
    add_index :landscapes, :the_geom, :spatial => true
        
    execute "create index idx_lat_long_radius on landscapes using gist(st_buffer(the_geom, radius))"
  end

  def self.down
    remove_index :occurrences, :the_geom
    remove_index :landscapes, :the_geom
    
    # execute "drop index idx_lat_long_radius on landscapes"
  end
end


