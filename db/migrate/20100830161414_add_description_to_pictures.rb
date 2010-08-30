class AddDescriptionToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :description, :text
    add_column :landscape_pictures, :description, :text
  end

  def self.down
    remove_column :pictures, :description
    remove_column :landscape_pictures, :description
  end
end
