require File.dirname(__FILE__) + '/acceptance_helper'

feature "Species" do

  scenario "A user visits the page of a species and saves it" do

    penguin = create_penguin

    visit homepage

    click_link 'Pygoscelis a...'

    page.should have_css("h1", :text => penguin.species)

    click_link 'Add to your guide'

    page.should have_css("p.times_added", :text => "1 time added")
    page.should have_css('ul#your_guide li p.title', :text => 'Pygoscelis a...')
    page.should have_no_css("a", :text => 'Add to your guide')
  end

end