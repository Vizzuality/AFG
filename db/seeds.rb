# Highlighted guides
penguins = Guide.create :name => 'View penguins',    :session_id => nil, :author => 'Fernando Blat', 
                         :highlighted => true, :downloads_count => 100, :species_count => 0, :popularity => 20, :published => true
Guide.create :name => 'View whales',      :session_id => nil, :author => 'Fernando Blat', 
                         :highlighted => true, :downloads_count => 50,  :species_count => 0, :popularity => 10, :published => true
Guide.create :name => 'View jellyfishes', :session_id => nil, :author => 'Fernando Blat', 
                         :highlighted => true, :downloads_count => 30,  :species_count => 0, :popularity => 30, :published => true

# Non highlighted guides
1.upto(20) do
  Guide.create :name => 'View ' + String.random(20), :session_id => nil, :author => String.random(20), 
                           :highlighted => false, :downloads_count => rand(100), :species_count => rand(100), 
                           :popularity => rand(100), :published => true
end

# Species
penguin = Species.create   :genus => 'Penguin',   :family => 'Arthropods', :name => 'Artantic'
whale = Species.create     :genus => 'Whale',     :family => 'Arthropods', :name => 'Common'
squid = Species.create     :genus => 'Squid',     :family => 'Arthropods', :name => 'Artantic'
jellyfish = Species.create :genus => 'Jellyfish', :family => 'Arthropods', :name => 'Common'

# Some relations
penguins.species << penguin

# Adminpassword
# AdminPassword.create :password => 'afg'