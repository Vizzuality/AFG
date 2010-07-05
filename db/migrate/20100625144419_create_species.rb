class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|
      t.string  :permalink
      t.string  :name
      t.integer :guides_count, :default => 0
      t.text    :description 
      
      t.timestamps
    end
  end

  def self.down
    drop_table :species
  end
end
