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


p = Point.from_x_y(-77, 0)
l = Landscape.new :name => 'Antartic Zone'
l.description = "All the antartic, just for tests"
l.featured = true
l.the_geom = p
l.save
l.image1_url = 'http://commondatastorage.googleapis.com/static.panoramio.com/photos/original/9363915.jpg'
l.save

p = Point.from_x_y(-78, 166)
l = Landscape.new :name => 'Spanish base'
l.the_geom = p
l.description = "Spanish scientific observatory"
l.save
l.image1_url = 'http://mw2.google.com/mw-panoramio/photos/medium/9363990.jpg'
l.image2_url = 'http://commondatastorage.googleapis.com/static.panoramio.com/photos/original/9363915.jpg'
l.save

1.upto(10){ |i| Guide.create :name => "Guia #{i}", :description => "Una guia #{i}", :author => "Fernando Blat", :published => true }

Guide.limit(3).each{ |g| g.update_attribute(:highlighted, true) }

g = Guide.first
Species.complete.limit(5).each do |species|
  g.add_entry('Species', species.id.to_s)
end
g.add_entry('Landscape', l.id.to_s)
