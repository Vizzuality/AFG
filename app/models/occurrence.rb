# == Schema Information
#
# Table name: occurrences
#
#  id         :integer         not null, primary key
#  species_id :integer         
#  date       :date            
#  created_at :datetime        
#  updated_at :datetime        
#  the_geom   :geometry        not null
#

class Occurrence < ActiveRecord::Base

  acts_as_geom :the_geom => :point
  
  validates_uniqueness_of :the_geom, :scope => :species_id
  
  belongs_to :species
  
end
