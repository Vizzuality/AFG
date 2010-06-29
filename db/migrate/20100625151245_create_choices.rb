class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.integer :guide_id
      t.integer :species_id
      t.integer :included_guide_id
      t.integer :position
      t.timestamps
    end
    
    add_index :choices, :included_guide_id
    add_index :choices, :species_id
    add_index :choices, :guide_id
    add_index :choices, :position
  end

  def self.down
    drop_table :choices
  end
end
