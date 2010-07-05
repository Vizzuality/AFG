class ActsAsScribeMigration < ActiveRecord::Migration

  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.string  :action
      t.integer :item_id
      t.string  :item_type
      t.timestamps
    end
    add_index :activities, [:item_type, :item_id]
    add_index :activities, [:user_id]
    add_index :activities, [:action]
    add_index :activities, [:created_at]
  end

  def self.down
    drop_table :activities
  end

end