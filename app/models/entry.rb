# == Schema Information
#
# Table name: entries
#
#  id             :integer         not null, primary key
#  guide_id       :integer         
#  element_id     :string(255)     
#  element_type   :string(255)     
#  position       :integer         
#  elements_count :integer         default(0)
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Entry < ActiveRecord::Base

  belongs_to :guide

  validates_uniqueness_of :element_id, :scope => [:guide_id, :element_type]
  
  after_create :update_counter_caches
  
  def element
    element_type.constantize.find(element_id)
  rescue
    nil
  end
  
  def full_name
    case element_type
    when 'Species'
      element.full_name
    when 'Landscape'
      element.name
    when 'Guide'
      element.name
    else
      element_id
    end
  end
  
  private

    def update_counter_caches
      case element_type
        when 'Species'
          Species.increment_counter(:guides_count, element_id.to_i)
          Guide.increment_counter(:species_count, guide_id)
        when 'Landscape'
          Landscape.increment_counter(:guides_count, element_id.to_i)
          Guide.increment_counter(:landscapes_count, guide_id)
        when 'Kingdom'
          species = Species.find_all_by_kingdom(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
        when 'Phylum'
          species = Species.find_all_by_phylum(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
        when 'Class'
          species = Species.find_all_by_t_class(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
        when 'Order'
          species = Species.find_all_by_t_order(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
        when 'Family'
          species = Species.find_all_by_family(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
        when 'Genus'
          species = Species.find_all_by_genus(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
      end
    end
  
end
