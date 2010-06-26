require 'test_helper'

class ChoiceTest < ActiveSupport::TestCase

  test "A choice must have a species_id or a guide_id" do
    species = create_species :name => 'Penguin'
    parent_guide = create_guide :name => 'Parent guide'
    guide = create_guide :name => 'Guide'
    
    choice = Choice.new :parent_guide => parent_guide
    assert !choice.valid?
    choice.species = species
    assert choice.valid?
    choice.species = nil
    choice.guide = guide
    assert choice.valid?
  end
  
end