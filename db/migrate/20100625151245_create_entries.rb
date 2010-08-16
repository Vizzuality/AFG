class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :guide_id
      t.string  :element_id
      t.string  :element_type
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
