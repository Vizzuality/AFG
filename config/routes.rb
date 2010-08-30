AFG::Application.routes.draw do |map|

  resources :occurrences

  root :to => "site#home"  

  get "maps" => 'maps#index', :as => 'maps'
  match 'maps/tiles' => 'maps#tiles', :as => 'tiles'

  match 'about' => 'site#about', :as => 'about'
  
  resources :guides, :only => [:index, :show] do
    get :undo, :on => :member
  end
  match 'guides/pdf/:id' => 'guides#pdf', :as => 'pdf_guide'
  match 'guides/update/current' => 'guides#update', :as => 'update_guide', :format => :js

  get 'taxonomy' => 'species#index', :as => 'species_taxonomy', :defaults => { :taxonomy => true }

  resources :landscapes, :only => [:index, :show]
  resources :species
  
  match 'entries/create' => 'entries#create', :as => 'create_entry'
  resources :entries, :only => [:destroy, :index]
  
  namespace :api do
    get "taxonomy" => "taxonomy#index", :format => :json
    get "images" => "images#show", :format => :json
  end
  
  get "api/maps/features" => "maps#features", :format => :json
  get "api/maps/static_map" => "maps#static_map", :format => :json

  namespace :admin do
    resources :landscapes
    resources :taxonomies
    resources :species, :except => [:show] do
      member do
        get :update_uid_and_taxon
      end
      resources :pictures, :except => [:index, :show]
    end
  end
  
  
  get "search" => 'search#index', :as => 'search'

  match 'authorizations/create_or_update' => 'authorizations#create_or_update', :as => 'authorizations_create_or_update'
  match 'authorizations' => 'authorizations#index'

end
