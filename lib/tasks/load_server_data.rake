namespace :afg do
  
  desc 'Load data from staging server'
  task :load_staging_data => :environment do
    current_database = ActiveRecord::Base.connection.current_database
    staging_server   = 'afg.vizzuality.com'
    
    system "rm #{RAILS_ROOT}/tmp/afg_staging.sql"
    system "rm #{RAILS_ROOT}/tmp/afg_images_staging.tar.gz"
    system "curl -0 http://#{staging_server}/afg_production.sql.gz > #{RAILS_ROOT}/tmp/afg_staging.sql.gz"
    system "curl -0 http://#{staging_server}/afg_images.tar.gz > #{RAILS_ROOT}/tmp/afg_images_staging.tar.gz"
    system "gunzip #{RAILS_ROOT}/tmp/afg_staging.sql.gz"
    system "/usr/local/pgsql/bin/dropdb -hlocalhost -Upostgres #{current_database}"
    system "/usr/local/pgsql/bin/createdb -hlocalhost -Upostgres #{current_database}"
    system "/usr/local/pgsql/bin/psql -hlocalhost -Upostgres -d#{current_database} -f #{RAILS_ROOT}/tmp/afg_staging.sql"
    system "rm #{RAILS_ROOT}/tmp/afg_staging.sql"
    system "tar xvzf #{RAILS_ROOT}/tmp/afg_images_staging.tar.gz -C #{RAILS_ROOT}/public/system/images/"
    system "rm #{RAILS_ROOT}/tmp/afg_images_staging.tar.gz"
  end
  
  desc 'Load data from production server'
  task :load_production_data => :environment do
    current_database  = ActiveRecord::Base.connection.current_database
    production_server = 'afg.scarmarbin.be'

    system "rm #{RAILS_ROOT}/tmp/afg_production.sql"
    system "rm #{RAILS_ROOT}/tmp/afg_images_production.tar.gz"
    system "curl -0 http://#{production_server}/afg_production.sql.gz > #{RAILS_ROOT}/tmp/afg_production.sql.gz"
    system "curl -0 http://#{production_server}/afg_images.tar.gz > #{RAILS_ROOT}/tmp/afg_images_production.tar.gz"
    system "gunzip #{RAILS_ROOT}/tmp/afg_production.sql.gz"
    system "/usr/local/pgsql/bin/dropdb -hlocalhost -Upostgres #{current_database}"
    system "/usr/local/pgsql/bin/createdb -hlocalhost -Upostgres #{current_database}"
    system "/usr/local/pgsql/bin/psql -hlocalhost -Upostgres -d#{current_database} -f #{RAILS_ROOT}/tmp/afg_production.sql"
    system "rm #{RAILS_ROOT}/tmp/afg_production.sql"
    system "tar xvzf #{RAILS_ROOT}/tmp/afg_images_production.tar.gz -C #{RAILS_ROOT}/public/system/images/"
    system "rm #{RAILS_ROOT}/tmp/afg_images_production.tar.gz"
  end
end