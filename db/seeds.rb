s = Species.new :name => 'cristata', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                :identification => 'Kathy Conlan (Canadian Museum of Nature)', :uid => '13776449', :family => 'Polynoidae', :genus => 'Barrukia',
                :species => 'Barrukia cristata', :featured => true, :highlighted => true
s.save

picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/samples/barrukia-cristata.jpg", "rb")
picture.save

s = Species.new :name => 'gigantea', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                :identification => 'Myriam Schuller', :uid => '13783975', :family => 'Polynoidae', :genus => 'Eulagisca',
                :species => 'Eulagisca gigantea', :featured => true, :highlighted => true
s.save

picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/samples/eulagisca-gigantea.jpg", "rb")
picture.save

s = Species.new :name => 'producta', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                :identification => 'Myriam Schuller', :uid => '13783975', :family => 'Aphroditidae', :genus => 'Laetmonice',
                :species => 'Laetmonice producta', :featured => true
s.save


l = Landscape.new :name => 'South Pole'
l.description = "El polo sur"
l.save