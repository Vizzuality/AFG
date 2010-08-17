class AddDistinguishingCharactersToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :distinguishing_characters, :text
  end

  def self.down
    remove_column :species, :distinguishing_characters
  end
end
