require 'test_helper'

class GuideTest < ActiveSupport::TestCase
  
  test "Permalink is created and is unique" do
    name = "I want to see penguins"
    name2 = "I want to see whales"
    g = Guide.new
    g.name = name
    g.save
    g.reload
    assert_equal g.permalink, name.sanitize
    g.name = name2
    g.save
    g.reload
    assert_equal g.permalink, name.sanitize

    g = Guide.new
    g.name = name
    g.save
    g.reload
    assert_equal g.permalink, name.sanitize + "-2"
  end
  
  test "Permalink sanitize with spanish characters" do
    name = "Quieró ver pingüiños"
    g = Guide.new
    g.name = name
    g.save
    g.reload
    assert_equal 'quiero-ver-pinguinos', g.permalink
  end
  
  test "A guide should undo the addition of a species" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    landscape = create_landscape :name => 'South Pole'
    
    guide.add_entry('Landscape', landscape.id.to_s)
    guide.add_entry('Species', species.id.to_s)
    
    guide.reload
    species.reload
    landscape.reload
    
    assert_equal "Species##{species.id}", guide.last_action
    
    assert_difference "Entry.count", -1 do
      guide.undo_last_action
    end
    
    guide.reload
    species.reload
    landscape.reload

    assert_equal 0, species.guides_count
    assert_equal 1, guide.landscapes_count
    assert_equal 0, guide.species_count
    assert_nil Entry.find_by_guide_id_and_element_type_and_element_id(guide.id, 'Species', species.id.to_s)
  end

  test "A guide should undo the addition of a landscape" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    landscape = create_landscape :name => 'South Pole'
    
    guide.add_entry('Species', species.id.to_s)
    guide.add_entry('Landscape', landscape.id.to_s)
    
    guide.reload
    species.reload
    landscape.reload
    
    assert_equal "Landscape##{landscape.id}", guide.last_action
    
    assert_difference "Entry.count", -1 do
      guide.undo_last_action
    end
    
    guide.reload
    species.reload
    landscape.reload

    assert_equal 0, landscape.guides_count
    assert_equal 0, guide.landscapes_count
    assert_equal 1, guide.species_count
    assert_nil Entry.find_by_guide_id_and_element_type_and_element_id(guide.id, 'Landscape', landscape.id.to_s)
  end
  
  test "A guide should undo the addition of a kingdom" do
    species1 = create_species :name => 'Penguin', :kingdom => 'Animals'
    species2 = create_species :name => 'Whale', :kingdom => 'Animals'
    species3 = create_species :name => 'Squid', :kingdom => 'Vegetals'
    guide = create_guide :name => 'Parent guide'
    
    guide.add_entry('Kingdom', 'Animals')
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal "Kingdom#Animals", guide.last_action
        
    assert_difference "Entry.count", -1 do
      guide.undo_last_action
    end
    
    guide.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 0, guide.species_count
    assert_equal 0, species1.guides_count
    assert_equal 0, species2.guides_count
  end

  test "A guide should undo the addition of a guide" do
    landscape = create_landscape :name => 'South Pole'
    template_guide = create_guide :name => 'Parent guide'
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'View penguins'
    species1 = create_species :name => 'Calamari', :t_order => 'OAnimals'
    species2 = create_species :name => 'Whale',    :t_order => 'OAnimals'
    species3 = create_species :name => 'Squid',    :t_order => 'Vegetals'
    
    guide.add_entry('Species', species3.id.to_s)
    
    template_guide.add_entry('Landscape', landscape.id.to_s)
    template_guide.add_entry('Species', species.id.to_s)
    template_guide.add_entry('Order', 'OAnimals')
    
    guide.add_entry('Guide', template_guide.id.to_s)
    
    guide.reload
    template_guide.reload
    species.reload
    landscape.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 2, species1.guides_count
    assert_equal 2, species2.guides_count
    
    assert_equal "Guide##{template_guide.id}", guide.last_action
    
    assert_difference "Entry.count", -3 do
      guide.undo_last_action
    end
    
    guide.reload
    template_guide.reload
    species.reload
    landscape.reload
    species1.reload
    species2.reload
    species3.reload
    
    assert_equal 1, species.guides_count
    assert_equal 1, landscape.guides_count
    assert_equal 1, species1.guides_count
    assert_equal 1, species2.guides_count
    assert_equal 1, species3.guides_count
    assert_equal 1, guide.species_count #species3
    assert_equal 1, guide.entries.count
  end

end
