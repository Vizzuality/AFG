# == Schema Information
#
# Table name: species
#
#  id           :integer         not null, primary key
#  permalink    :string(255)     
#  name         :string(255)     
#  guides_count :integer         default(0)
#  description  :text            
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Species < ActiveRecord::Base
  
  has_permalink :name
  
  has_many :entries
  has_many :guides, :through => :entries
  
  validates_presence_of :name

  def to_param
    "#{id}-#{permalink}"
  end
  
end
