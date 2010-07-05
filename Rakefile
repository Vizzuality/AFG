# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Rails::Application.load_tasks

namespace :db do
  desc 'Removes database. Run migrations. Run annotate_modes. Run db:test:prepare'
  task :redo => :environment do
    File.delete("#{Rails.root}/db/development.sqlite3")
    Rake::Task["db:migrate"].invoke
    Rake::Task["annotate_models"].invoke
    Rake::Task["db:test:prepare"].invoke
    Rake::Task["db:seed"].invoke
  end
end