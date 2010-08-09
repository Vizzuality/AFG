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
#  locality     :string(255)     
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Picture < ActiveRecord::Base

  belongs_to :species

  def self.pictures_directory(family)
    "/images/data/#{family}"
  end
  
  def public_filename(size=:big)
    file_path = self.class.pictures_directory(species.family) + '/' + filename
    if File.file?(file_path)
      file_path
    else
      case size
        when :big
          "/images/default_big.png"
        when :small
          "/images/default_small.png"
        end
    end
  end
  
  def self.find_random(limit = 10)
    limit = Picture.count < limit ? Picture.count : limit
    result = []
    tries = 0
    while result.size < limit && tries < 3
      picture_id = rand(limit) + 1
      if picture = Picture.find_by_id(picture_id)
        result << picture
      else
        tries += 1
      end
    end
    result
  end
  
  
end
