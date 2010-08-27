class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :guide_id
      t.string  :element_id
      t.string  :element_type
      t.integer :position
      t.integer :elements_count, :default => 0
      t.timestamps
    end
    
    add_index :entries, :guide_id    
    add_index :entries, [:guide_id, :created_at], :name => 'idx_guide_id_created_at'
    add_index :entries, [:guide_id, :element_type], :name => 'idx_guide_id_element_type'
    add_index :entries, [:guide_id, :element_type, :element_id], :name => 'idx_guide_id_e_type_and_e_id'
  end

  def self.down
    drop_table :entries
  end
end
