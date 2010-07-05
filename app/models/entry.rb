# == Schema Information
#
# Table name: entries
#
#  id                :integer         not null, primary key
#  guide_id          :integer         
#  species_id        :integer         
#  included_guide_id :integer         
#  position          :integer         
#  created_at        :datetime        
#  updated_at        :datetime        
#

class Entry < ActiveRecord::Base

  belongs_to :species, :counter_cache => :guides_count
  
  belongs_to :guide, :counter_cache => :species_count
  belongs_to :included_guide, :class_name => 'Guide', :foreign_key => 'included_guide_id', :counter_cache => :popularity
  
  validate :validate_associated_to_guide_or_species

  after_create :add_species, :if => Proc.new{ |entry| entry.type_of_entry == :included_guide }
  after_create :register_activity
  
  def name
    included_guide.try(:name) || species.try(:name)
  end
  
  def type_of_entry
    included_guide ? :included_guide : :species
  end
  
  private
  
    # An entry as one guide_id or one species_id, but not both at the same time  
    def validate_associated_to_guide_or_species
      unless included_guide_id || species_id
        errors.add(:base, "An entry has to be related with a species or with a guide")
      end
    end
    
    def add_species
      included_guide.species.each do |species|
        guide.species << species
      end
    end
    
    def register_activity
      Activity.report(0, type_of_entry, type_of_entry == :included_guide ? included_guide : species)
    end
  
end