class CreateLandscapes < ActiveRecord::Migration
  def self.up
    create_table :landscapes do |t|
      t.string :name
      t.string :permalink
      t.string :source
      t.text :description
      t.string :related_url
      t.multi_polygon :the_geom, :srid => 4326, :null => false
      t.string :image1_url
      t.string :image2_url
      t.string :image3_url
      t.string :image4_url
      t.timestamps
    end
  end

  def self.down
    drop_table :landscapes
  end
end
