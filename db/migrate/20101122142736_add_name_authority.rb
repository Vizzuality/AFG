class AddNameAuthority < ActiveRecord::Migration
  def self.up
    add_column :species, :name_author, :string 
  end

  def self.down
    remove_column :species, :name_author 
  end
end
