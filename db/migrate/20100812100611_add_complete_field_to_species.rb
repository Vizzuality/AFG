class AddCompleteFieldToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :complete, :boolean, :default => false
  end

  def self.down
    remove_column :species, :complete
  end
end
