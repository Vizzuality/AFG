class AddParentGuideIdToGuides < ActiveRecord::Migration
  def self.up
    add_column :guides, :parent_guide_id, :integer
  end

  def self.down
    remove_column :guides, :parent_guide_id
  end
end
