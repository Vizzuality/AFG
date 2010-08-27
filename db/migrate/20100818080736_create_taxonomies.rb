class CreateTaxonomies < ActiveRecord::Migration
  def self.up
    create_table :taxonomies do |t|
      t.string  :name
      t.string  :hierarchy
      t.integer :downloads_count, :default => 0
      t.text    :description
      t.text    :distinguishing_characters
    end
    
    add_index :taxonomies, [:hierarchy, :name], :name => 'idx_hierarchy_name'
  end

  def self.down
    drop_table :taxonomies
  end
end
