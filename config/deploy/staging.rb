role :app, linode_staging
role :web, linode_staging
role :db,  linode_staging, :primary => true

set :branch, "staging"