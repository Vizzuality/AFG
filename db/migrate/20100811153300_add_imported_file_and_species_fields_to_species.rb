class AddImportedFileAndSpeciesFieldsToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :imported_file, :string
    add_column :species, :species, :string
  end

  def self.down
    remove_column :species, :imported_file
    remove_column :species, :species
  end
end
