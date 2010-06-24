require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guides of species" do
  
  scenario "A user visits the site for first time" do
    
    assert_equal 0, Guide.count
    
    visit '/'
    
    assert_equal 1, Guide.count
    
    visit '/about'

    assert_equal 1, Guide.count
    
  end

  scenario "A user visits the site for first time" do
    true.should == true
  end
  
end