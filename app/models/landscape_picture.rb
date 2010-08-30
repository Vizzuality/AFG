# == Schema Information
#
# Table name: landscape_pictures
#
#  id                 :integer         not null, primary key
#  original_image_url :string(255)     
#  landscape_id       :integer         
#  image_file_name    :string(255)     
#  image_content_type :string(255)     
#  image_file_size    :integer         
#  image_updated_at   :datetime        
#  created_at         :datetime        
#  updated_at         :datetime        
#  description        :text            
#

class LandscapePicture < ActiveRecord::Base
  
  belongs_to :landscape
  
  has_attached_file :image, :styles => { :small => "70x47#", :medium => "168x110#", :large => "247x158#", :huge => "896x381#" }  
  
end
