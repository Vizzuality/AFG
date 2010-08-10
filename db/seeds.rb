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
penguin = Species.create   :genus => 'Penguin',   :family => 'Arthropods', :name => 'Artantic', :common_name => 'Pingüino Antártico', 
                           :description => "La familia Spheniscidae abarca al conjunto de aves marinas comúnmente llamadas pingüinos. Los primeros europeos en observar estas aves del Hemisferio Sur fueron exploradores ibéricos, que las llamaron pájaros niño o pájaros bobos por su andar torpe y erguido y al ser un ave incapaz de volar. Poco más tarde, cuando los primeros británicos vieron a estos animales los llamaron Penguins (del gaélico penwyn, pen = cabeza y qwyn = blanca), que era el nombre que daban al alca gigante del Atlántico norte (Pinguinus impennis). Sin embargo y pese a las aparentes similitudes resultado de la convergencia evolutiva, los pingüinos del Hemisferio Norte no están relacionados con los del Hemisferio Sur. Tras la extinción del alca gigante a fines del siglo XIX, el nombre pingüino se perpetuó en las aves de la familia Spheniscidae. Existen 18 diferentes especies de pingüinos.",
                           :identification => "Fue identificado por John Ford",
                           :distribution => "Los pingüinos son las únicas aves vivientes no voladoras adaptadas al buceo propulsado por las alas.",
                           :ecology => "Los pingüinos son las únicas aves vivientes no voladoras adaptadas al buceo propulsado por las alas.",
                           :size => "200x80 cm",
                           :depth => "No muy depth"
whale = Species.create     :genus => 'Whale',     :family => 'Arthropods', :name => 'Common'
squid = Species.create     :genus => 'Squid',     :family => 'Arthropods', :name => 'Artantic'
jellyfish = Species.create :genus => 'Jellyfish', :family => 'Arthropods', :name => 'Common'

# Some relations
penguins.species << penguin

# Adminpassword
# AdminPassword.create :password => 'afg'