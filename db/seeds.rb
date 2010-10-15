# Specie 1
s = Species.new :name => 'cristata', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata',
                :identification => 'Kathy Conlan (Canadian Museum of Nature)', :uid => '13776449', :family => 'Polynoidae', :genus => 'Barrukia',
                :species => 'Barrukia cristata', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
                :distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

#Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Ammothea1.car.jpg", "rb")
picture.save

# Specie 2
s = Species.new :name => 'gigantea', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata',
                :identification => 'Myriam Schuller', :uid => '13783975', :family => 'Polynoidae', :genus => 'Eulagisca',
                :species => 'Eulagisca gigantea', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
                :distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Austropallene1.JPG", "rb")
picture.save

# Specie 3
s = Species.new :name => 'producta', :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata',
                :identification => 'Myriam Schuller', :uid => '13783975', :family => 'Aphroditidae', :genus => 'Laetmonice',
                :species => 'Laetmonice producta', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
                :distinguishing_characters=>'lorem ipsum dolor sit amet'

s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Ceratoserolis1.din.JPG", "rb")
picture.save


################## ADDING MORE DATA
# Specie 4
s = Species.new :name => 'nutrix', :identification => 'Stefan Hain', :genus => 'Inversiula', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet', :distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Colossendeis1.sco.JPG", "rb")
picture.save

# Specie 5
s = Species.new :name => 'laevis', :identification => 'Brigitte Hilbig', :genus => 'Polyeunoa', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
:distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Colossendeis2.rob.JPG", "rb")
picture.save

# Specie 6
s = Species.new :name => 'gigantea', :identification => 'Myriam Schuller', :genus => 'Eulagisca', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
:distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Epimeria1.sp.JPG", "rb")
picture.save

# Specie 6
s = Species.new :name => 'cristata', :identification => 'Stephanie Kaiser', :genus => 'Barrukia', :featured => true, :highlighted => true, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
:distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

# Picture asociated
picture = Picture.new :species => s
picture.image = File.open("#{Rails.root}/public/images/data/Arthropods/Eurypodius1.JPG", "rb")
picture.save

# Specie 7
s = Species.new :name => 'trissophyllus', :identification => 'Brigitte Hilbig', :genus => 'Aglaophamus', :featured => true, :highlighted => false, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
:distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save

# Specie 8
s = Species.new :name => 'cincinnatus', :identification => 'Anne-Nina Loerz', :genus => 'Thelepus', :featured => true, :highlighted => false, :description=>'lorem ipsum dolor sit amet', :distribution=>'lorem ipsum dolor sit amet',
:distinguishing_characters=>'lorem ipsum dolor sit amet'
s.save


# Point 1
p = Point.from_x_y(0, -77)
l = Landscape.new :name => 'Antarctic Zone'
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
1.upto(10){ |i| Guide.create :name => "Guia #{i}", :description => "Una guia #{i}", :author => "Fernando Blat", :published => true }

Guide.limit(3).each{ |g| g.update_attribute(:highlighted, true) }

g = Guide.first
Species.complete.limit(5).each do |species|
  g.add_entry('Species', species.id.to_s)
end

g.add_entry('Landscape', l.id.to_s)
g.add_entry('Class', 'Malacostraca')


1.upto(100) do |i|
s = Species.new :name => "producta #{i}", :phylum => 'Annelida', :kingdom => 'Animalia', :t_class => 'Polychaeta', :t_order => 'Aciculata',
                :identification => 'Myriam Schuller', :uid => "137835#{i}", :family => 'Aphroditidae', :genus => 'Laetmonice',
                :species => "Laetmonice producta #{i}", :featured => true, :highlighted => true, :description=>"lorem ipsum dolor sit amet #{i}", :distribution=>"lorem ipsum dolor sit amet #{i}",
                :distinguishing_characters=>"lorem ipsum dolor sit amet #{i}"

s.save
end