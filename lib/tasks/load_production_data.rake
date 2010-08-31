namespace :afg do
  
  def from_file(filepath)
    return '' unless File.file?(filepath)
    File.open(filepath).read.split(':')[1..-1].join(':')
  end
  
  desc 'Load production data'
  task :load_production_data do
    system "rm #{RAILS_ROOT}/tmp/afg_production.sql"
    system "rm #{RAILS_ROOT}/tmp/afg_images.tar.gz"
    system "curl -0 http://afg.vizzuality.com/afg_production.sql.gz > #{RAILS_ROOT}/tmp/afg_production.sql.gz"
    system "curl -0 http://afg.vizzuality.com/afg_images.tar.gz > #{RAILS_ROOT}/tmp/afg_images.tar.gz"
    system "gunzip #{RAILS_ROOT}/tmp/afg_production.sql.gz"
    system "/usr/local/pgsql/bin/dropdb -hlocalhost -Upostgres afg_development"
    system "/usr/local/pgsql/bin/createdb -hlocalhost -Upostgres afg_development"
    system "/usr/local/pgsql/bin/psql -hlocalhost -Upostgres -dafg_development -f #{RAILS_ROOT}/tmp/afg_production.sql"
    system "rm #{RAILS_ROOT}/tmp/afg_production.sql"
    system "tar xvzf #{RAILS_ROOT}/tmp/afg_images.tar.gz -C #{RAILS_ROOT}/public/system/images/"
    system "rm #{RAILS_ROOT}/tmp/afg_images.tar.gz"
  end
end