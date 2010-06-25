require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guides of species" do
  
  scenario "A user visits the site for first time" do
    
    assert_equal 0, Guide.count
    
    visit '/'
    
    assert_equal 1, Guide.count
    
    visit '/about'

    assert_equal 1, Guide.count
    
  end

  scenario "A user visits the guides page" do
    
    # highlighted guides
    penguins  = create_guide :name => 'View penguins',    :session_id => nil, :author => 'Fernando Blat', 
                             :highlighted => true, :downloads_count => 100, :species_count => 33, :popularity => 20
    whales    = create_guide :name => 'View whales',      :session_id => nil, :author => 'Fernando Blat', 
                             :highlighted => true, :downloads_count => 50,  :species_count => 16, :popularity => 10
    jellyfish = create_guide :name => 'View jellyfishes', :session_id => nil, :author => 'Fernando Blat', 
                             :highlighted => true, :downloads_count => 30,  :species_count => 50, :popularity => 30
    crabs     = create_guide :name => nil, :session_id => 'random_session_id', :author => nil, 
                            :highlighted => true, :downloads_count => 30,  :species_count => 50, :popularity => 30

    # non-highlighted guides
    octopus = create_guide :name => 'View octopus', :session_id => nil, :author => 'Fernando Blat', 
                           :highlighted => false, :downloads_count => 10, :species_count => 50, :popularity => 30
    squids =  create_guide :name => 'View squids',  :session_id => nil, :author => 'Fernando Blat', 
                           :highlighted => false, :downloads_count => 30, :species_count => 150, :popularity => 20
    seal =    create_guide :name => nil,   :session_id => 'random_session_id', :author => nil, 
                           :highlighted => false, :downloads_count => 30, :species_count => 50, :popularity => 30
    
    visit "/"
    
    click "Guides"
    
    within(:css, "div.header_guides") do
      page.should have_css("h4", :count => 3)
      page.should have_css("h4", :text => "View penguins")
      page.should have_css("h4", :text => "View whales")
      page.should have_css("h4", :text => "View jellyfishes")
    end
    
    within(:css, "div#guides_left") do
      page.should have_css("h4", :count => 2)
      page.should have_css("h4", :text => "View octopus")
      page.should have_css("h4", :text => "View squids")
    end
    
  end
  
end