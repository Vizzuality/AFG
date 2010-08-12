namespace :afg do
  
  def from_file(filepath)
    return '' unless File.file?(filepath)
    File.open(filepath).read.split(':')[1..-1].join(':')
  end
  
  desc 'Import data'
  task :import_data => :environment do
    species_errors = []
    pictures_errors = []
    # Families in the data files
    %W{
      Annelida Arthropods Ascidians Bryozoa Cnidaria Echinodermata Mollusca Prorifera Various
    }.each do |importing_file|
      # Species
      puts
      puts
      puts "Importing species from #{importing_file}"
      data_directory = "#{Rails.root}/doc/data"
      filename = "#{importing_file}.csv"
      FasterCSV.foreach(data_directory + '/' + filename) do |line|
        next if line[0] == 'Genus'
        next if line[0].blank? && line[1].blank?
        
        if line[1].blank? && line[2].blank? && line[3].blank?
          importing_file = line[0].humanize
          puts
          puts
          puts "Importing species from #{importing_file}"
          next
        end
        
        # There are some lines that have more 2 records more
        offset_in_line = 0
        offset_in_line += 2 if line.size == 18
        
        begin
          unless species = Species.find_by_name_and_genus(line[1], line[0])
            species = Species.new
            species.imported_file = importing_file
            species.genus = line[0]
            species.name = line[1]
            species.common_name = line[offset_in_line+6] if line[offset_in_line+6] != 'None' && line[offset_in_line+6] != '*'
            species.identification = line[offset_in_line+9]
        
            species.description  = from_file(data_directory + '/' + importing_file + '/' + line[offset_in_line+10]) unless line[offset_in_line+10] == '*' || line[offset_in_line+10].blank?
            species.distribution = from_file(data_directory + '/' + importing_file + '/' + line[offset_in_line+11]) unless line[offset_in_line+11] == '*' || line[offset_in_line+11].blank?
            species.ecology      = from_file(data_directory + '/' + importing_file + '/' + line[offset_in_line+12]) unless line[offset_in_line+12] == '*' || line[offset_in_line+12].blank?
            species.size         = from_file(data_directory + '/' + importing_file + '/' + line[offset_in_line+13]) unless line[offset_in_line+13] == '*' || line[offset_in_line+13].blank?
            species.depth        = from_file(data_directory + '/' + importing_file + '/' + line[offset_in_line+14]) unless line[offset_in_line+14] == '*' || line[offset_in_line+14].blank?
            species.reference    = from_file(data_directory + '/' + importing_file + '/' + line[offset_in_line+15]) unless line[offset_in_line+15] == '*' || line[offset_in_line+15].blank?
        
            if species.save
              putc '.'
            else
              putc 'e'
              species_errors << {:line => line, :errors => species.errors.full_messages}
              next
            end
          else
            putc '.'
          end
        rescue
          putc 'e'
          species_errors << {:line => line, :errors => $!}
          next
        end
        
        # Pictures
        next if line[offset_in_line+2] == '*'
        picture = Picture.new
        picture.filename = line[offset_in_line+2]
        picture.title = line[offset_in_line+3]
        picture.caption = line[offset_in_line+4]
        picture.photographer = line[offset_in_line+5]
        picture.locality = line[offset_in_line+7]
        picture.species = species
        if picture.save
          putc '.'
        else
          putc 'e'
          pictures_errors << {:line => line, :errors => picture.errors.full_messages + " -- " + $!}
        end
      end
    end
    
    puts
    puts
    puts '====================================='
    puts "Species import finished"
    puts "#{species_errors.size} errors"
    puts "#{Species.count} species imported"
    puts "#{Species.complete.count} species imported and complete"
    if species_errors.size > 0
      puts 
      puts "Errors:"
      puts '  ' + species_errors.inspect
    end
    puts
    puts "Pictures import finished"
    puts "#{pictures_errors.size} errors"
    puts "#{Picture.count} pictures imported"
    if pictures_errors.size > 0
      puts 
      puts "Errors:"
      puts '  ' + pictures_errors.inspect
    end
  end
end