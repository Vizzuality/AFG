class AddPdfFieldToGuide < ActiveRecord::Migration
  def self.up
    add_column :guides, :pdf_file, :string
  end

  def self.down
    remove_column :guides, :pdf_file
  end
end
