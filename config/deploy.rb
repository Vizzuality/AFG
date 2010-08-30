require "bundler/capistrano"

default_run_options[:pty] = true

set :application, 'afg'

set :scm, :git
# set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :scm_user, 'ubuntu'
set :repository,  "git@github.com:jatorre/AFG.git"
ssh_options[:forward_agent] = true
set :keep_releases, 5

set :slice, '178.79.131.104'
set :user,  'ubuntu'

set :deploy_to, "/home/ubuntu/www/#{application}"

role :app, slice
role :web, slice
role :db,  slice, :primary => true

after  "deploy:update_code", :run_migrations, :symlinks

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
end

desc "Migraciones"
task :run_migrations, :roles => [:app] do
  run <<-CMD
    export RAILS_ENV=production &&
    cd #{release_path} &&
    rake db:migrate
  CMD
end
 
task :symlinks, :roles => [:app] do
  run <<-CMD
    ln -s #{shared_path}/system/images #{release_path}/public/system/images;
    ln -s #{shared_path}/pdfs #{release_path}/public/;
    ln -s #{shared_path}/cache #{release_path}/public/;
  CMD
end

# On setup:
#   - create shared/system
#   - create shared/pdfs
#   - create shared/cache
#   - ...