# == Schema Information
#
# Table name: species
#
#  id             :integer         not null, primary key
#  uid            :integer         
#  permalink      :string(255)     
#  name           :string(255)     
#  guides_count   :integer         default(0)
#  genus          :string(255)     
#  family         :string(255)     
#  common_name    :string(255)     
#  description    :text            
#  identification :string(255)     
#  distribution   :text            
#  ecology        :text            
#  size           :text            
#  depth          :text            
#  reference      :text            
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Species < ActiveRecord::Base
  
  FAMILIES = %W{
    Annelida Arthropods Ascidians Bryozoa Cnidaria Echinodermata Mollusca Prorifera Various
  }

  has_permalink :name
  
  has_many :entries
  has_many :guides, :through => :entries
  has_many :pictures
  
  validates_presence_of :name

  def to_param
    "#{id}-#{permalink}"
  end
  
  def picture
    pictures.try(:first)
  end
  
  def self.families; FAMILIES end
  
end
