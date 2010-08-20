# == Schema Information
#
# Table name: occurrences
#
#  id         :integer         not null, primary key
#  species_id :integer         
#  date       :date            
#  created_at :datetime        
#  updated_at :datetime        
#  the_geom   :geometry        
#

class Occurrence < ActiveRecord::Base

  acts_as_geom :the_geom => :point
  
  validates_uniqueness_of :the_geom
  
  belongs_to :species
  
end
