AFG::Application.routes.draw do

  resources :occurrences

  root :to => "site#home"

  get "maps" => 'maps#index', :as => 'maps'
  match 'maps/tiles' => 'maps#tiles', :as => 'tiles'

  match 'about' => 'site#about', :as => 'about'
  match 'raise_exception' => 'site#raise_exception'

  resources :guides, :only => [:index, :show] do
    get :undo, :on => :member
  end
  match 'guides/pdf/:permalink' => 'guides#pdf', :as => 'pdf_guide'
  match 'guides/update/current' => 'guides#update', :as => 'update_guide', :format => :js

  get 'taxonomy' => 'species#index', :as => 'species_taxonomy', :defaults => { :taxonomy => true }
  get 'species/get_uid/:query' => 'species#get_uid', :as => 'species_get_uid'
  get 'species/get_taxon/:query' => 'species#get_taxon', :as => 'species_get_taxon'

  resources :landscapes, :path => 'places', :only => [:index, :show]
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
    resources :guides
    resources :species, :except => [:show] do
      get :update_uid_and_taxon, :on => :member
      resources :pictures, :except => [:index, :show]
    end
  end


  get "search" => 'search#index', :as => 'search'

  match 'authorizations/create_or_update' => 'authorizations#create_or_update', :as => 'authorizations_create_or_update'
  match 'authorizations' => 'authorizations#index'

end
