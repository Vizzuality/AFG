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
s = Species.new :name => 'Carbasea ovoidea', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'David Barnes', :family => 'Polynoidae', :genus => 'Carbasea',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 5
s = Species.new :name => 'Isosecuriflustra tenuis', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Brigitte Hilbig', :family => 'Polynoidae', :genus => 'Isosecuriflustra',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 6
s = Species.new :name => 'Tubulipora tubigera', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Kathy Conlan', :family => 'Polynoidae', :genus => 'Tubulipora',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 6
s = Species.new :name => 'Kymella polaris', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Stefan Hain', :family => 'Polynoidae', :genus => 'Kymella',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 7
s = Species.new :name => 'Isosecuriflustra rubefacta', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Louise Allcock', :family => 'Polynoidae', :genus => 'Isosecuriflustra',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 8
s = Species.new :name => 'Inversiula nutrix', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Stefan Hain', :family => 'Polynoidae', :genus => 'Inversiula',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 9
s = Species.new :name => 'Himantozoum antarcticum', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Paul Dayton', :family => 'Polynoidae', :genus => 'Himantozoum',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 10
s = Species.new :name => 'Celleporella antartica', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Peter Brueggemann', :family => 'Polynoidae', :genus => 'Celleporella',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 10
s = Species.new :name => 'Polyeunoa laevis', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Brigitte Hilbig', :family => 'Polynoidae', :genus => 'Polyeunoa',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 11
s = Species.new :name => 'Ophelina breviata', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Tomas Munilla', :family => 'Polynoidae', :genus => 'Ophelina',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 12
s = Species.new :name => 'Eulagisca gigantea', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Myriam Schuller', :family => 'Polynoidae', :genus => 'Eulagisca',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 13
s = Species.new :name => 'Barrukia cristata', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Stephanie Kaiser', :family => 'Polynoidae', :genus => 'Barrukia',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
s.save

# Specie 14
s = Species.new :name => 'Aglaophamus trissophyllus', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Brigitte Hilbig', :family => 'Polynoidae', :genus => 'Aglaophamus',
                :species => 'Trissophyllus', :featured => true, :highlighted => true
s.save

# Specie 15
s = Species.new :name => 'Thelepus cincinnatus', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Aberrantidae', :t_order => 'Aciculata', 
                :identification => 'Anne-Nina Loerz', :family => 'Polynoidae', :genus => 'Thelepus',
                :species => 'Trissophyllus', :featured => true, :highlighted => false
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