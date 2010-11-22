namespace :afg do

  desc 'Add authority names to taxon without it'
  task :add_authority => :environment do
    Species.complete.each do |species|
      begin
        puts "http://data.scarmarbin.be/taxon/#{species.uid}?format=xml"
        response = open("http://data.scarmarbin.be/taxon/#{species.uid}?format=xml").read
        doc = Nokogiri::XML(response)
        author = doc.xpath("//authority").first.try(:text)
        species.name_author = author
        species.save
        #sleep 1
      rescue
        puts "#{$!}"
      end
    end
  end

end