class CreateLandscapePictures < ActiveRecord::Migration
  def self.up
    create_table :landscape_pictures do |t|
      t.string :original_image_url
      t.integer :landscape_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :landscape_pictures
  end
end
