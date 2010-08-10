class AddTaxonomiesToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :kingdom, :string
    add_column :species, :phylum, :string
    add_column :species, :t_class, :string
    add_column :species, :t_order, :string
  end

  def self.down
    remove_column :species, :kingdom
    remove_column :species, :phylum
    remove_column :species, :t_class
    remove_column :species, :t_order
  end
end
