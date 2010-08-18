require 'test_helper'

class SpeciesTest < ActiveSupport::TestCase

  test "Permalink is created and is unique" do
    name = "I want to see penguins"
    g = Species.new
    g.name = name
    g.save
    g.reload
    assert_equal g.permalink, name.sanitize

    g = Species.new
    g.name = name
    g.save
    g.reload
    assert_equal g.permalink, name.sanitize + "-2"
  end
  
  test "Permalink sanitize with spanish characters" do
    name = "Quieró ver pingüiños"
    g = Species.new
    g.name = name
    g.save
    g.reload
    assert_equal 'quiero-ver-pinguinos', g.permalink
  end
  
  test "Create a species complete should create its taxonomy" do
    assert_equal 0, Taxonomy.count
    s = Species.new :name => 'cristata', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                    :identification => 'Kathy Conlan (Canadian Museum of Nature)', :uid => '13776449', :family => 'Polynoidae', :genus => 'Barrukia',
                    :species => 'Barrukia cristata', :featured => true, :highlighted => true
    s.save
    assert !s.new_record?
    assert s.valid?
    
    assert_equal 6, Taxonomy.count
    assert_not_nil Taxonomy.find_by_name_and_hierarchy('Animalia', 'kingdom')
    assert_not_nil Taxonomy.find_by_name_and_hierarchy('Annelida', 'phylum')
    assert_not_nil Taxonomy.find_by_name_and_hierarchy('Polychaeta', 'class')
    assert_not_nil Taxonomy.find_by_name_and_hierarchy('Aciculata', 'order')
    assert_not_nil Taxonomy.find_by_name_and_hierarchy('Polynoidae', 'family')
    assert_not_nil Taxonomy.find_by_name_and_hierarchy('Barrukia', 'genus')
  end

end
