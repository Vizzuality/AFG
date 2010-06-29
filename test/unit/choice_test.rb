require 'test_helper'

class ChoiceTest < ActiveSupport::TestCase

  test "A choice must have a species_id or a guide_id" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    included_guide = create_guide :name => 'Guide'
    
    choice = Choice.new :guide => guide
    assert !choice.valid?
    choice.species = species
    assert choice.valid?
    choice.species = nil
    choice.included_guide = included_guide
    assert choice.valid?
  end
  
  test "Relations between guides, species, choices and cache_counters" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    included_guide = create_guide :name => 'Guide'
    
    assert guide.species.empty?
    guide.species << species
    guide.reload
    species.reload
    assert guide.species.include?(species)
    assert species.guides.include?(guide)
    assert_equal 1, species.guides_count
    
    assert guide.included_guides.empty?
    guide.included_guides << included_guide
    guide.reload
    included_guide.reload
    assert guide.included_guides.include?(included_guide)
    assert_equal 1, included_guide.popularity
  end
  
  test ":name method" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    included_guide = create_guide :name => 'Guide'
    
    guide.species << species
    assert_equal species.name, guide.choices.first.name
    guide.included_guides << included_guide
    assert_equal included_guide.name, guide.choices.first.name
  end
  
end