class AddLastActionToGuide < ActiveRecord::Migration
  def self.up
    add_column :guides, :last_action, :string
  end

  def self.down
    remove_column :guides, :last_action
  end
end
