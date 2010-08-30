require File.dirname(__FILE__) + '/acceptance_helper'

feature "Species" do
  
  scenario "A user visits the page of a species and saves it" do
    penguin = create_species :name => 'Penguin'
    
    visit '/'
    
    page.find(:css, "div.species_list h4 a", :text => 'Penguin').click
    
    page.should have_css("h2", :text => penguin.name)
    
    click "Add to your guide"
    
    page.should have_css("p.times_added", :text => "1 time added")
    page.should have_css("div.long ul#sortable li.single p.title", :text => penguin.name)
    page.should_not have_css("a", :text => 'Add your guide')
  end
  
end