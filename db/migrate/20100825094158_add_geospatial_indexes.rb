class AddGeospatialIndexes < ActiveRecord::Migration
  def self.up
    add_index :occurrences, :the_geom, :spatial => true
  end

  def self.down
    remove_index :occurrences, :the_geom
  end
end
