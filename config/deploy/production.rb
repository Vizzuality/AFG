role :app, linode_production
role :web, linode_production
role :db,  linode_production, :primary => true

set :branch, "production"
