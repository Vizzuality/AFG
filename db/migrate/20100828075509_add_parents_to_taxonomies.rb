class AddParentsToTaxonomies < ActiveRecord::Migration
  def self.up
    add_column :taxonomies, :parents, :string
  end

  def self.down
    remove_column :taxonomies, :parents
  end
end
