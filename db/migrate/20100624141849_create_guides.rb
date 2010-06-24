class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides do |t|
      t.string :name
      t.string :author
      t.text :description
      t.integer :species_count, :default => 0
      t.integer :downloads_count, :default => 0
      t.string :session_id
      t.integer :loving, :default => 0

      t.timestamps
    end
    
    add_index :guides, :session_id
    add_index :guides, :loving
    add_index :guides, :created_at
    add_index :guides, :name
    add_index :guides, :author
  end

  def self.down
    drop_table :guides
  end
end
