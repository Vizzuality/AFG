require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guides of species" do

  scenario "A user visits the site for first time" do

    assert_equal 0, Guide.count

    visit homepage

    assert_equal 1, Guide.count

    visit about

    assert_equal 1, Guide.count

  end

  scenario "A user visits the guides page" do

    # highlighted guides
    penguins  = create_guide :name => 'View penguins',    :session_id => nil, :author => 'Fernando Blat',
                             :highlighted => true, :downloads_count => 100, :species_count => 33, :popularity => 20,
                             :published => true
    whales    = create_guide :name => 'View whales',      :session_id => nil, :author => 'Fernando Blat',
                             :highlighted => true, :downloads_count => 50,  :species_count => 16, :popularity => 10,
                             :published => true
    jellyfish = create_guide :name => 'View jellyfishes', :session_id => nil, :author => 'Fernando Blat',
                             :highlighted => true, :downloads_count => 30,  :species_count => 50, :popularity => 30,
                             :published => true
    crabs     = create_guide :name => nil, :session_id => 'random_session_id', :author => nil,
                             :highlighted => true, :downloads_count => 30,  :species_count => 50, :popularity => 30,
                             :published => true

    # non-highlighted guides
    octopus = create_guide :name => 'View octopus', :session_id => nil, :author => 'Fernando Blat',
                           :highlighted => false, :downloads_count => 10, :species_count => 50, :popularity => 30,
                           :published => true
    squids =  create_guide :name => 'View squids',  :session_id => nil, :author => 'Fernando Blat',
                           :highlighted => false, :downloads_count => 30, :species_count => 150, :popularity => 20,
                           :published => true
    seal =    create_guide :name => nil,   :session_id => 'random_session_id', :author => nil,
                           :highlighted => false, :downloads_count => 30, :species_count => 50, :popularity => 30,
                           :published => true

    visit homepage

    click_link "Guides"

    within("div.guides_header") do
      page.should have_css("h4", :count => 3)
      page.should have_css("h4", :text => "View penguins")
      page.should have_css("h4", :text => "View whales")
      page.should have_css("h4", :text => "View jellyfishes")
    end

    within("div#guides_left") do
      page.should have_css("h4", :count => 2)
      page.should have_css("h4", :text => "View octopus")
      page.should have_css("h4", :text => "View squids")
    end

  end

  scenario "A user visits a guide" do
    penguins  = create_guide :name => 'View penguins',    :session_id => nil, :author => 'Fernando Blat',
                             :highlighted => true, :downloads_count => 100, :species_count => 33, :popularity => 20,
                             :description => "This is a wadus guide"

    visit guide penguins

    page.should have_css("div.guide_header h1", :text => penguins.name)
    page.should have_css("p.by", :text => "created by #{penguins.author} on #{penguins.updated_at.strftime("%B %dth, %Y")}")
    page.should have_css("p.downloads_data", :text => "#{pluralize(penguins.downloads_count,"DOWNLOADS")}")
    page.should have_css("p.info_guide", :text => penguins.description)
    page.should have_css("p.species_rank", :text => "#{penguins.species_count} SPECIEs")
  end

  scenario "Save a guide" do
    penguin = create_species  :name    => 'Penguin',
                              :kingdom => 'Animalia',
                              :t_order => 'Ciconiiformes',
                              :t_class => 'Aves',
                              :genus   => 'Pygoscelis',
                              :phylum  => 'Chordata',
                              :family  => 'Spheniscidae',
                              :species => 'Pygoscelis adeliae'

    penguins_guide  = create_guide :name => 'View penguins',    :session_id => nil, :author => 'Fernando Blat',
                             :highlighted => true, :downloads_count => 100, :species_count => 33, :popularity => 20,
                             :description => "This is a wadus guide"
    penguins_guide.add_entry('Species', penguin.id)

    visit guide penguins_guide
    page.should have_css("p.downloads_data span", :text => "#{penguins_guide.downloads_count} DOWNLOADs")

    assert_difference "Entry.count", 1 do
      click_link "use it as template"
    end
    page.should have_css("div.guide_header div.large h1", :text => penguins_guide.name)
    pending("'use it as template' link must dissapear after clicking it?")
    # page.should have_no_css("p.template", :text => 'use it as template')
  end

  context 'With javascript enabled' do
    background do
      enable_javascript
    end

    scenario "A user creates a guide and publishes it" do
      penguin = create_penguin

      visit homepage

      # # Creates a new session, listening at port 3001 in order to generate PDFs
      # create_pdf_session

      click_link "Pygoscelis a..."

      page.should have_css("h1", :text => penguin.species)

      click_link "Add to your guide"

      click_link 'publish_and_download'

      page.should have_css('div.info a', :text => 'Complete', :visible => true)
      click_link 'Complete'

      fill_in('YOUR NAME', :with => '')
      fill_in('GUIDE TITLE', :with => 'My trip to the antarctic')
      fill_in('DESCRIPTION', :with => "In this guide I have planned my trip to the Antarctic")

      click_link "Proceed to download"

      page.should have_css('#error_invalid_author p', :text => "The author of the guide can't be blank")

      fill_in('YOUR NAME', :with => 'Fernando Blat')
      fill_in('GUIDE TITLE', :with => 'My trip to the antarctic')
      fill_in('DESCRIPTION', :with => "In this guide I have planned my trip to the Antarctic")

      click_link "Proceed to download"

      Guide.count.should be 1
      guide = Guide.last
      guide.published?.should be true

      pdf_uri = "/pdfs/#{guide.pdf_name}"
      page.should have_css('#pdf_path', :text => 'Download', :href => pdf_uri)

      click_link 'Download'

      pending('pdf should exists')
      # pdf_should_exists pdf_uri
    end

  end
end