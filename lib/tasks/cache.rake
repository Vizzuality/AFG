namespace :afg do
  namespace :cache do
    desc 'Create landscapes maps cache'
    task :landscapes_maps => :environment do
      Landscape.all.each do |l|
        Landscape.maps_cache_delete(l.id)
        Landscape.maps_cache_set(l.id, StaticMap.generate_typed_map(:landscapes, l.id))
      end
    end

    desc 'Create species maps cache'
    task :species_maps => :environment do
      Species.all.each do |s|
        Species.maps_cache_delete(s.id)
        Species.maps_cache_set(s.id, StaticMap.generate_typed_map(:species, s.id))
      end
    end

    desc 'Create all maps cache'
    task :all_maps => [:environment, :landscapes_maps, :species_maps]

    desc 'Download PDF files and store them in disk'
    task :pdfs => :environment do
      Guide.published.each do |guide|
        next if guide.pdf_file?
        guide.generate_pdf!("#{DOMAIN}/", false)
      end
    end
  end
end