class AddHabitatToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :habitat, :string
  end

  def self.down
    remove_column :species, :habitat
  end
end
