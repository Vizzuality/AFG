# == Schema Information
#
# Table name: landscapes
#
#  id           :integer         not null, primary key
#  name         :string(255)     
#  permalink    :string(255)     
#  source       :string(255)     
#  description  :text            
#  related_url  :string(255)     
#  image1_url   :string(255)     
#  image2_url   :string(255)     
#  image3_url   :string(255)     
#  image4_url   :string(255)     
#  guides_count :integer         default(0)
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Landscape < ActiveRecord::Base
  
  before_validation :set_permalink
  
  def self.find_by_term(q)
    q = "%#{q}%"
    where(["name like ? OR description like ?", q, q]).order("guides_count DESC")
  end
  
  def sort_by_attribute
    :guides_count
  end
  
  private
  
    def set_permalink
      return unless self.permalink.blank?
      self.permalink = name.sanitize unless name.blank?
      temporal_permalink = permalink
      if self.class.exists?(:permalink => temporal_permalink)
        i = 2
        temporal_permalink = permalink + "-#{i}"
        while(self.class.exists?(:permalink => temporal_permalink)) do
          i+=1
          temporal_permalink = permalink + "-#{i}"
        end
        self.permalink = temporal_permalink
      end
    end
end
