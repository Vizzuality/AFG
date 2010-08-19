class CreateLandscapes < ActiveRecord::Migration
  def self.up
    create_table :landscapes do |t|
      t.string :name
      t.string :permalink
      t.string :source
      t.text :description
      t.string :related_url
      t.string :image1_url
      t.string :image2_url
      t.string :image3_url
      t.string :image4_url
      t.integer :guides_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :landscapes
  end
end
