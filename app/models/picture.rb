# == Schema Information
#
# Table name: pictures
#
#  id           :integer         not null, primary key
#  species_id   :integer         
#  filename     :string(255)     
#  title        :string(255)     
#  caption      :string(255)     
#  photographer :string(255)     
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Picture < ActiveRecord::Base

  belongs_to :species
  
  def self.pictures_directory(family)
    "#{Rails.root}/public/images/data/#{family}"
  end
  
  def public_filename
    self.class.pictures_directory(species.family) + '/' + filename
  end
  
end
