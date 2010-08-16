require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  
  test "An species should be added to a guide" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Species', species.id.to_s)
    end
    
    guide.reload
    species.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Species', entry.element_type
    assert_equal species.id.to_s, entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 1, guide.species_count
    assert_equal 0, guide.landscapes_count
    assert_equal 1, species.guides_count
  end

  test "A landscape should be added to a guide" do
    landscape = create_landscape :name => 'South Pole'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Landscape', landscape.id.to_s)
    end
    
    guide.reload
    landscape.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Landscape', entry.element_type
    assert_equal landscape.id.to_s, entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 0, guide.species_count
    assert_equal 1, guide.landscapes_count
    assert_equal 1, landscape.guides_count
  end
  
  test "A kingdom should be added to a guide" do
    species1 = create_species :name => 'Penguin', :kingdom => 'Animals'
    species2 = create_species :name => 'Whale', :kingdom => 'Animals'
    species3 = create_species :name => 'Squid', :kingdom => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Kingdom', 'Animals')
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Kingdom', entry.element_type
    assert_equal 'Animals', entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 2, guide.species_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 0, species3.guides_count
  end
  
  test "A phylum should be added to a guide" do
    species1 = create_species :name => 'Penguin', :phylum => 'PAnimals'
    species2 = create_species :name => 'Whale',   :phylum => 'PAnimals'
    species3 = create_species :name => 'Squid',   :phylum => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Phylum', 'PAnimals')
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Phylum', entry.element_type
    assert_equal 'PAnimals', entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 2, guide.species_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 0, species3.guides_count
  end
  
  test "A class should be added to a guide" do
    species1 = create_species :name => 'Penguin', :t_class => 'CAnimals'
    species2 = create_species :name => 'Whale',   :t_class => 'CAnimals'
    species3 = create_species :name => 'Squid',   :t_class => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Class', 'CAnimals')
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Class', entry.element_type
    assert_equal 'CAnimals', entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 2, guide.species_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 0, species3.guides_count
  end
  
  test "A order should be added to a guide" do
    species1 = create_species :name => 'Penguin', :t_order => 'OAnimals'
    species2 = create_species :name => 'Whale',   :t_order => 'OAnimals'
    species3 = create_species :name => 'Squid',   :t_order => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Order', 'OAnimals')
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Order', entry.element_type
    assert_equal 'OAnimals', entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 2, guide.species_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 0, species3.guides_count
  end
  
  test "A family should be added to a guide" do
    species1 = create_species :name => 'Penguin', :family => 'FAnimals'
    species2 = create_species :name => 'Whale',   :family => 'FAnimals'
    species3 = create_species :name => 'Squid',   :family => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Family', 'FAnimals')
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Family', entry.element_type
    assert_equal 'FAnimals', entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 2, guide.species_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 0, species3.guides_count
  end
  
  test "A genus should be added to a guide" do
    species1 = create_species :name => 'Penguin', :genus => 'GAnimals'
    species2 = create_species :name => 'Whale',   :genus => 'GAnimals'
    species3 = create_species :name => 'Squid',   :genus => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    assert_difference 'Entry.count' do
      guide.add_entry('Genus', 'GAnimals')
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, Entry.count
    entry = Entry.first
    assert_equal guide.id, entry.guide_id
    assert_equal 'Genus', entry.element_type
    assert_equal 'GAnimals', entry.element_id
    assert_equal [entry], guide.entries
    assert_equal 2, guide.species_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 0, species3.guides_count
  end
  
  test "A guide should be used as template of a guide" do
    landscape = create_landscape :name => 'South Pole'
    template_guide = create_guide :name => 'Parent guide'
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'View penguins'
    
    template_guide.add_entry('Landscape', landscape.id.to_s)
    template_guide.add_entry('Species', species.id.to_s)
    
    assert_difference 'Entry.count', 2 do
      guide.add_entry('Guide', template_guide.id.to_s)
    end
    
    guide.reload
    template_guide.reload
    species.reload
    landscape.reload
    
    assert_equal 4, Entry.count
    assert_equal 2, species.guides_count
    assert_equal 2, landscape.guides_count
    assert_equal 1, guide.species_count
    assert_equal 1, guide.landscapes_count
    
    assert_not_nil Entry.find_by_guide_id_and_element_type_and_element_id(guide.id, 'Landscape', landscape.id.to_s)
    assert_not_nil Entry.find_by_guide_id_and_element_type_and_element_id(guide.id, 'Species', species.id.to_s)
  end

end