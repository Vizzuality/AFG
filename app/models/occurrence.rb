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
  
  after_create :expire_species_map_cache
  before_destroy :expire_species_map_cache
  
  belongs_to :species
  
  private
  
    def expire_species_map_cache
      Species.maps_cache_delete(species.id)
    end
  
end
