# == Schema Information
#
# Table name: pictures
#
#  id                 :integer         not null, primary key
#  species_id         :integer
#  filename           :string(255)
#  title              :string(255)
#  caption            :string(255)
#  photographer       :string(255)
#  locality           :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  description        :text
#

class Picture < ActiveRecord::Base

  belongs_to :species

  validates_presence_of :image_file_name

  has_attached_file :image, :styles => { :small => "48x48#", :sidebar => "76x76#", :medium => "168x110#", :large => "247x158#", :huge => "896x381#", :gallery => "896x896>"},
                    :url => "/system/:attachment/:id/:style/:image_file_name"

  def before_save
    return if image_file_name.blank?
    extension = File.extname(image_file_name)
    self.image_file_name = "#{image_file_name.sanitize}#{extension}"
  end

end
