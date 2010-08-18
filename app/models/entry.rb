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
  
  after_create :increment_counter_caches
  before_destroy :decrement_counter_caches
  
  def self.per_page; 5 end
  
  def element
    case element_type
    when 'Species'
      Species.find(element_id)
    when 'Landscape'
      Landscape.find(element_id)
    when 'Guide'
      Guide.find(element_id)
    else
      Species.send("find_by_#{element_type.downcase}".to_sym, element_id)
    end
  rescue
    nil
  end
  
  def activity_type
    case element_type
    when 'Species'
      'species'
    when 'Landscape'
      'landscape'
    when 'Guide'
      'guide'
    else
      'taxonomy'
    end
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

    def increment_counter_caches
      case element_type
        when 'Species'
          Species.increment_counter(:guides_count, element_id.to_i)
          Guide.increment_counter(:species_count, guide_id)
        when 'Landscape'
          Landscape.increment_counter(:guides_count, element_id.to_i)
          Guide.increment_counter(:landscapes_count, guide_id)
        when 'Kingdom'
          species = Species.complete.find_all_by_kingdom(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('kingdom', element_id)
            taxonomy.increment(:downloads_count)
            taxonomy.save
          end
        when 'Phylum'
          species = Species.complete.find_all_by_phylum(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('phylum', element_id)
            taxonomy.increment(:downloads_count)
            taxonomy.save
          end
        when 'Class'
          species = Species.complete.find_all_by_t_class(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('class', element_id)
            taxonomy.increment(:downloads_count)
            taxonomy.save
          end
        when 'Order'
          species = Species.complete.find_all_by_t_order(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('order', element_id)
            taxonomy.increment(:downloads_count)
            taxonomy.save
          end
        when 'Family'
          species = Species.complete.find_all_by_family(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('family', element_id)
            taxonomy.increment(:downloads_count)
            taxonomy.save
          end
        when 'Genus'
          species = Species.complete.find_all_by_genus(element_id)
          guide.update_attribute(:species_count, guide.species_count + species.size)
          species.each do |s|
            s.increment(:guides_count)
            s.save
          end
          update_attribute(:elements_count, species.size)
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('genus', element_id)
            taxonomy.increment(:downloads_count)
            taxonomy.save
          end
      end
    end
    
    def decrement_counter_caches
      case element_type
        when 'Species'
          Species.decrement_counter(:guides_count, element_id.to_i)
          Guide.decrement_counter(:species_count, guide_id)
        when 'Landscape'
          Landscape.decrement_counter(:guides_count, element_id.to_i)
          Guide.decrement_counter(:landscapes_count, guide_id)
        when 'Kingdom'
          species = Species.complete.find_all_by_kingdom(element_id)
          guide.update_attribute(:species_count, guide.species_count - species.size)
          species.each do |s|
            s.decrement(:guides_count)
            s.save
          end
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('kingdom', element_id)
            taxonomy.decrement(:downloads_count)
            taxonomy.save
          end
        when 'Phylum'
          species = Species.complete.find_all_by_phylum(element_id)
          guide.update_attribute(:species_count, guide.species_count - species.size)
          species.each do |s|
            s.decrement(:guides_count)
            s.save
          end
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('phylum', element_id)
            taxonomy.decrement(:downloads_count)
            taxonomy.save
          end
        when 'Class'
          species = Species.complete.find_all_by_t_class(element_id)
          guide.update_attribute(:species_count, guide.species_count - species.size)
          species.each do |s|
            s.decrement(:guides_count)
            s.save
          end
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('class', element_id)
            taxonomy.decrement(:downloads_count)
            taxonomy.save
          end
        when 'Order'
          species = Species.complete.find_all_by_t_order(element_id)
          guide.update_attribute(:species_count, guide.species_count - species.size)
          species.each do |s|
            s.decrement(:guides_count)
            s.save
          end
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('order', element_id)
            taxonomy.decrement(:downloads_count)
            taxonomy.save
          end
        when 'Family'
          species = Species.complete.find_all_by_family(element_id)
          guide.update_attribute(:species_count, guide.species_count - species.size)
          species.each do |s|
            s.decrement(:guides_count)
            s.save
          end
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('family', element_id)
            taxonomy.decrement(:downloads_count)
            taxonomy.save
          end
        when 'Genus'
          species = Species.complete.find_all_by_genus(element_id)
          guide.update_attribute(:species_count, guide.species_count - species.size)
          species.each do |s|
            s.decrement(:guides_count)
            s.save
          end
          if taxonomy = Taxonomy.find_by_hierarchy_and_name('genus', element_id)
            taxonomy.decrement(:downloads_count)
            taxonomy.save
          end
      end
    end
  
end
