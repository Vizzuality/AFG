class CreateTaxonomies < ActiveRecord::Migration
  def self.up
    create_table :taxonomies do |t|
      t.string  :name
      t.string  :hierarchy
      t.integer :downloads_count, :default => 0
      t.text    :description
      t.text    :distinguishing_characters
    end
  end

  def self.down
    drop_table :taxonomies
  end
end
