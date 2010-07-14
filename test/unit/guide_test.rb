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

end
