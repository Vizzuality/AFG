class AddSourceLinkAndSourceName < ActiveRecord::Migration
  def self.up
    add_column :landscapes, :source_link, :string
    add_column :landscapes, :source_name, :string
    add_column :species, :source_link, :string
    add_column :species, :source_name, :string
  end

  def self.down
    remove_column :landscapes, :source_link
    remove_column :landscapes, :source_name
    remove_column :species, :source_link
    remove_column :species, :source_name
  end
end
