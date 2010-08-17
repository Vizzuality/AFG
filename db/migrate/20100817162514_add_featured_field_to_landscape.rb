class AddFeaturedFieldToLandscape < ActiveRecord::Migration
  def self.up
    add_column :landscapes, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :landscapes, :featured
  end
end
