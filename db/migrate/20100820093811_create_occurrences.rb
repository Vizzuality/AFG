class CreateOccurrences < ActiveRecord::Migration
  def self.up
    create_table :occurrences do |t|
      t.integer :species_id
      t.date :date
      t.point :the_geom, :srid => 4326, :null => false
      t.timestamps
    end
    
    add_index :occurrences, :species_id
  end

  def self.down
    drop_table :occurrences
  end
end
