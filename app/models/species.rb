# == Schema Information
#
# Table name: species
#
#  id           :integer         not null, primary key
#  name         :string(255)     
#  guides_count :integer         default(0)
#  description  :text            
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Species < ActiveRecord::Base
  
  has_many :entries
  has_many :guides, :through => :entries
  
  validates_presence_of :name
  
end
