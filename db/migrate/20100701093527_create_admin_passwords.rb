class CreateAdminPasswords < ActiveRecord::Migration
  def self.up
    create_table :admin_passwords do |t|
      t.string :password
    end
  end

  def self.down
    drop_table :admin_passwords
  end
end
