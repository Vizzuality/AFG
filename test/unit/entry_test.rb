require 'test_helper'

class EntryTest < ActiveSupport::TestCase

  test "A entry must have a species_id or a guide_id" do
    species = create_species :name => 'Penguin'
    guide = create_guide :name => 'Parent guide'
    included_guide = create_guide :name => 'Guide'
    
    entry = Entry.new :guide => guide
    assert !entry.valid?
    entry.species = species
    assert entry.valid?
    entry.species = nil
    entry.included_guide = included_guide
    assert entry.valid?
  end
  
  test "Relations between guides, species, entries and cache_counters" do
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
    assert_equal species.name, guide.entries.first.name
    guide.included_guides << included_guide
    assert_equal included_guide.name, guide.entries.first.name
  end
  
  test "Saving a guide should add the species included in the guide" do
    penguin = create_species :name => 'Penguin'
    whale = create_species :name => 'Whale'
    guide = create_guide :name => 'Parent guide'
    included_guide = create_guide :name => 'Guide'
    included_guide.species << penguin
    included_guide.species << whale
    
    guide.included_guides << included_guide
    assert guide.species.include?(penguin)
    assert guide.species.include?(whale)
    assert_equal 2, guide.species.count
  end
  
  test "Save a guide and a species creates different activities" do
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
    
    assert_equal 1, Activity.count
    assert_equal 'species', Activity.last.action
    
    assert guide.included_guides.empty?
    guide.included_guides << included_guide
    guide.reload
    included_guide.reload
    assert guide.included_guides.include?(included_guide)
    assert_equal 1, included_guide.popularity

    assert_equal 2, Activity.count
    assert_equal 'included_guide', Activity.last.action
  end
  
end