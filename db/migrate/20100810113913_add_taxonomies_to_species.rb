class AddTaxonomiesToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :kingdom, :string
    add_column :species, :phylum, :string
    add_column :species, :t_class, :string
    add_column :species, :t_order, :string
    
    add_index :species, :kingdom
    add_index :species, :phylum
    add_index :species, :t_class
    add_index :species, :t_order
  end

  def self.down
    remove_index :species, :kingdom
    remove_index :species, :phylum
    remove_index :species, :t_class
    remove_index :species, :t_order
    
    remove_column :species, :kingdom
    remove_column :species, :phylum
    remove_column :species, :t_class
    remove_column :species, :t_order
  end
end
