class AddDescriptionToLandscapesPictures < ActiveRecord::Migration
  def self.up
    remove_column :landscape_pictures, :description
    add_column :landscapes, :image1_description, :text
    add_column :landscapes, :image2_description, :text
    add_column :landscapes, :image3_description, :text
    add_column :landscapes, :image4_description, :text
  end

  def self.down
    add_column :landscape_pictures, :description, :text
    remove_column :landscapes, :image1_description
    remove_column :landscapes, :image2_description
    remove_column :landscapes, :image3_description
    remove_column :landscapes, :image4_description
  end
end
