# == Schema Information
#
# Table name: choices
#
#  id              :integer         not null, primary key
#  guide_id        :integer         
#  species_id      :integer         
#  parent_guide_id :integer         
#  position        :integer         
#  created_at      :datetime        
#  updated_at      :datetime        
#

class Choice < ActiveRecord::Base
  
  # parent_guide is the guide where all species and guides are included
  belongs_to :parent_guide, :counter_cache => :guides_count, :class_name => 'Guide'
  
  belongs_to :guide
  belongs_to :species, :counter_cache => :species_count

  validate :validate_associated_to_guide_or_species

  private
  
    # A choice as one guide_id or one species_id, but not both at the same time  
    def validate_associated_to_guide_or_species
      unless guide_id || species_id
        errors.add(:base, "A choice has to be related with a species or with a guide")
      end
    end
  
end
