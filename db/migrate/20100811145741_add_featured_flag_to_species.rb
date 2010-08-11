class AddFeaturedFlagToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :species, :featured
  end
end
