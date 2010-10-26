namespace :afg do
  namespace :pictures do

    desc "Reprocess pictures' paperclip attachments"
    task :reprocess => :environment do
      # rake paperclip:refresh doens't work with Rails 3.
      # There's a pendent pull request that will solve this issue http://github.com/thoughtbot/paperclip/pull/306
      # Until then, instead of forking the original paperclip repository, 
      # this rake task will help us to reprocess the pictures' attachments.
      errors = []

      puts "Reprocessing species' pictures"
      puts '------------------------------'

      nothing_to_do = true

      Picture.find_each do |picture|
        break if picture.species.nil? || picture.all_image_urls_exists?
        nothing_to_do = false
        begin
          species_name = picture.species.common_name.present? ? picture.species.common_name : picture.species.name

          puts msg = "reprocessing pictures for #{species_name}"
          puts msg.chars.map{'-'}.join

          picture.image.reprocess!
          errors << picture.errors if picture.errors.present?
        rescue Exception => e
          errors << "Unexpected error processing species' picture. id => #{picture.id} Error message: #{e.inspect}"
        end
      end
      puts 'Nothing to do' if nothing_to_do

      puts ''
      puts ''
      puts "Reprocessing landscapes' pictures"
      puts '------------------------------'

      nothing_to_do = true

      LandscapePicture.find_each do |picture|
        break if picture.landscape.nil? || picture.all_image_urls_exists?
        nothing_to_do = false
        begin
          landscape_name = picture.landscape.name.present? ? picture.landscape.name : 'Unknown landscape'

          puts msg = "reprocessing pictures for #{landscape_name}"
          puts msg.chars.map{'-'}.join

          picture.image.reprocess!
          errors << picture.errors if picture.errors.present?
        rescue Exception => e
          errors << "Unexpected error processing landscape's picture. id => #{picture.id}. Error message: #{e.inspect}"
        end
      end
      puts 'Nothing to do' if nothing_to_do

      puts ''
      puts ''
      puts "Reprocessing done!"
      puts '------------------'
      if errors.present?
        puts "Errors encountered:"
        errors.each do |error|
          puts error
        end
      end
    end

  end
  

end