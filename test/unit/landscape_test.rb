require 'test_helper'

class LandscapeTest < ActiveSupport::TestCase

  test "Permalink is created and is unique" do
    name = "I want to see penguins"
    name2 = "I want to see whales"
    l = Landscape.new
    l.name = name
    l.save
    l.reload
    assert_equal l.permalink, name.sanitize
    l.name = name2
    l.save
    l.reload
    assert_equal l.permalink, name.sanitize

    l = Landscape.new
    l.name = name
    l.save
    l.reload
    assert_equal l.permalink, name.sanitize + "-2"
  end
  
  test "Permalink sanitize with spanish characters" do
    name = "Quieró ver pingüiños"
    l = Landscape.new
    l.name = name
    l.save
    l.reload
    assert_equal 'quiero-ver-pinguinos', l.permalink
  end

end
