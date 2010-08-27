# Specie 1
s = Species.new :name => 'cristata', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                :identification => 'Kathy Conlan (Canadian Museum of Nature)', :uid => '13776449', :family => 'Polynoidae', :genus => 'Barrukia',
                :species => 'Barrukia cristata', :featured => true, :highlighted => true
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/samples/barrukia-cristata.jpg", "rb")
picture.save

# Specie 2
s = Species.new :name => 'gigantea', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                :identification => 'Myriam Schuller', :uid => '13783975', :family => 'Polynoidae', :genus => 'Eulagisca',
                :species => 'Eulagisca gigantea', :featured => true, :highlighted => true
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/samples/eulagisca-gigantea.jpg", "rb")
picture.save

# Specie 3
s = Species.new :name => 'producta', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata', 
                :identification => 'Myriam Schuller', :uid => '13783975', :family => 'Aphroditidae', :genus => 'Laetmonice',
                :species => 'Laetmonice producta', :featured => true
s.save

################## ADDING MORE DATA
# Specie 4
s = Species.new :name => 'ovoidea', :identification => 'David Barnes', :genus => 'Carbasea',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 5
s = Species.new :name => 'tenuis', :identification => 'Brigitte Hilbig', :genus => 'Isosecuriflustra', :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 6
s = Species.new :name => 'Tubulipora tubigera', :identification => 'Kathy Conlan', :genus => 'Tubulipora', :family => 'Polynoidae', :featured => true, :highlighted => true
s.save

# Specie 6
s = Species.new :name => 'Kymella polaris', :identification => 'Stefan Hain', :genus => 'Kymella', :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 7
s = Species.new :name => 'rubefacta', :identification => 'Louise Allcock', :genus => 'Isosecuriflustra', :featured => true, :highlighted => true
s.save

# Specie 8
s = Species.new :name => 'nutrix', :identification => 'Stefan Hain', :genus => 'Inversiula', :featured => true, :highlighted => false
s.save

# Specie 9
s = Species.new :name => 'antarcticum', :identification => 'Paul Dayton', :genus => 'Himantozoum', :featured => true, :highlighted => true
s.save

# Specie 10
s = Species.new :name => 'antartica', :identification => 'Peter Brueggemann', :genus => 'Celleporella', :featured => true, :highlighted => false
s.save

# Specie 10
s = Species.new :name => 'laevis', :identification => 'Brigitte Hilbig', :genus => 'Polyeunoa', :featured => true, :highlighted => true
s.save

# Specie 11
s = Species.new :name => 'breviata', :identification => 'Tomas Munilla', :genus => 'Ophelina', :featured => true, :highlighted => false
s.save

# Specie 12
s = Species.new :name => 'gigantea', :identification => 'Myriam Schuller', :genus => 'Eulagisca', :featured => true, :highlighted => true
s.save

# Specie 13
s = Species.new :name => 'cristata', :identification => 'Stephanie Kaiser', :genus => 'Barrukia', :featured => true, :highlighted => false
s.save

# Specie 14
s = Species.new :name => 'trissophyllus', :identification => 'Brigitte Hilbig', :genus => 'Aglaophamus', :featured => true, :highlighted => true
s.save

# Specie 15
s = Species.new :name => 'cincinnatus', :identification => 'Anne-Nina Loerz', :genus => 'Thelepus', :featured => true, :highlighted => false
s.save

# Point 1
p = Point.from_x_y(0, -77)
l = Landscape.new :name => 'Antartic Zone'
l.description = "All the antartic, just for tests"
l.featured = true
l.the_geom = p
l.save
l.image1_url = 'http://commondatastorage.googleapis.com/static.panoramio.com/photos/original/9363915.jpg'
l.save

# Point 2
p = Point.from_x_y(166,-78)
l = Landscape.new :name => 'Spanish base'
l.the_geom = p
l.description = "Spanish scientific observatory"
l.save
l.image1_url = 'http://mw2.google.com/mw-panoramio/photos/medium/9363990.jpg'
l.image2_url = 'http://commondatastorage.googleapis.com/static.panoramio.com/photos/original/9363915.jpg'
l.save


# Creating guides
1.upto(15){ |i| Guide.create :name => "Guia #{i}", :description => "Una guia #{i}", :author => "Fernando Blat", :published => true }
Guide.limit(3).each{ |g| g.update_attribute(:highlighted, true) }

g = Guide.first
Species.complete.limit(5).each do |species|
  g.add_entry('Species', species.id.to_s)
end

g.add_entry('Landscape', l.id.to_s)
g.add_entry('Class', 'Malacostraca')