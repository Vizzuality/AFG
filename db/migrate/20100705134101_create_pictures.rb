class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer :species_id
      t.string :filename
      t.string :title
      t.string :caption
      t.string :photographer
      t.string :locality

      t.timestamps
    end
    
    add_index :pictures, :species_id
  end

  def self.down
    drop_table :pictures
  end
end
