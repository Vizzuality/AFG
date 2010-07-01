class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :guide_id
      t.integer :species_id
      t.integer :included_guide_id
      t.integer :position
      t.timestamps
    end
    
    add_index :entries, :included_guide_id
    add_index :entries, :species_id
    add_index :entries, :guide_id
    add_index :entries, :position
  end

  def self.down
    drop_table :entries
  end
end
