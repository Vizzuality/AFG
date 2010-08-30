namespace :afg do
  
  desc 'Import occurrences from complete species'
  task :import_occurrences => :environment do
    puts "Importing occurrences from #{Species.complete.count} species"
    created = 0
    Species.complete.each do |species|
      occurrences = Species.get_occurrences(species.uid)
      unless occurrences.empty?
        Species.transaction do
          species.occurrences.clear
          occurrences.each do |occurrence|
            new_occurrence = species.occurrences.new :date => occurrence[:date], :the_geom => Point.from_lon_lat(occurrence[:lon], occurrence[:lat])
            if new_occurrence.save
              putc '.'
              created += 1
            end
          end
        end
      end
    end
    puts
    puts "Created #{created} occurrences"
  end
  
end