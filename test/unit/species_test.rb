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

end
