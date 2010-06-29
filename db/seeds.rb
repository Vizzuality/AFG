# Highlighted guides
penguins = Guide.create :name => 'View penguins',    :session_id => nil, :author => 'Fernando Blat', 
                         :highlighted => true, :downloads_count => 100, :species_count => 0, :popularity => 20
Guide.create :name => 'View whales',      :session_id => nil, :author => 'Fernando Blat', 
                         :highlighted => true, :downloads_count => 50,  :species_count => 0, :popularity => 10
Guide.create :name => 'View jellyfishes', :session_id => nil, :author => 'Fernando Blat', 
                         :highlighted => true, :downloads_count => 30,  :species_count => 0, :popularity => 30

# Non highlighted guides
1.upto(20) do
  Guide.create :name => 'View ' + String.random(20), :session_id => nil, :author => String.random(20), 
                           :highlighted => false, :downloads_count => rand(100), :species_count => rand(100), :popularity => rand(100)
end

# Species
penguin = Species.create :name => 'Penguin'
whale = Species.create :name => 'Whale'
squid = Species.create :name => 'Squid'
jellyfish = Species.create :name => 'Jellyfish'

# Some relations
penguins.species << penguin