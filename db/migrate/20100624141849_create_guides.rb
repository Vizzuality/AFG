class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides do |t|
      t.string  :permalink
      t.string  :name
      t.string  :author
      t.text    :description
      t.integer :species_count,    :default => 0
      t.integer :landscapes_count, :default => 0
      t.integer :downloads_count,  :default => 0
      t.string  :session_id
      t.integer :popularity,       :default => 0
      t.boolean :highlighted,      :default => false
      t.boolean :published,        :default => false

      t.timestamps
    end
    
    add_index :guides, [:published, :highlighted]
    add_index :guides, :session_id
  end

  def self.down
    drop_table :guides
  end
end
