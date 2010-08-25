AFG::Application.routes.draw do |map|

  resources :occurrences

  root :to => "site#home"  

  get "maps" => 'maps#index', :as => 'maps'
  match 'maps/tiles' => 'maps#tiles', :as => 'tiles'

  match 'about' => 'site#about', :as => 'about'
  
  resources :guides, :only => [:index, :show, :update] do
    get :undo, :on => :member
  end
  match 'guides/pdf/:id' => 'guides#pdf', :as => 'pdf_guide'
  match 'guides/edit/current' => 'guides#edit', :as => 'edit_guide'

  get 'taxonomy' => 'species#index', :as => 'species_taxonomy', :defaults => { :taxonomy => true }

  resources :landscapes, :only => [:index, :show]
  resources :species
  resources :entries, :only => [:create, :destroy, :index]
  
  namespace :api do
    get "taxonomy" => "taxonomy#index", :as => 'taxonomy', :format => :json
  end

  namespace :admin do
    resources :landscapes
    resources :taxonomies
    resources :species, :except => [:show] do
      resources :pictures, :except => [:index, :show]
    end
  end
  
  
  get "search" => 'search#index', :as => 'search'

  match 'authorizations/create_or_update' => 'authorizations#create_or_update', :as => 'authorizations_create_or_update'
  match 'authorizations' => 'authorizations#index'

end
