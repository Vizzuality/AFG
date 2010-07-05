class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|
      t.integer :uid
      t.string  :permalink
      t.string  :name
      t.integer :guides_count, :default => 0
      t.string  :genus
      t.string  :family
      t.string  :common_name
      t.text    :description
      t.string  :identification
      t.text    :distribution 
      t.text    :ecology
      t.text    :size
      t.text    :depth
      t.text    :reference
      
      t.timestamps
    end
  end

  def self.down
    drop_table :species
  end
end
