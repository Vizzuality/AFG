class AddSpeciesNewFields < ActiveRecord::Migration
  def self.up
    add_column :species, :behaviour, :text
    add_column :species, :reproductive, :text
    add_column :species, :feeding_behaviour, :text
  end

  def self.down
    remove_column :species, :behaviour
    remove_column :species, :reproductive
    remove_column :species, :feeding_behaviour
  end
end
