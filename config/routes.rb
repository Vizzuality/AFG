AFG::Application.routes.draw do |map|

  root :to => "site#home"  

  get "maps" => 'maps#index', :as => 'maps'
  match 'maps/tiles' => 'maps#tiles', :as => 'tiles'

  match 'about' => 'site#about', :as => 'about'
  
  resources :guides, :only => [:index, :show, :update]
  match 'guides/pdf/:id' => 'guides#pdf', :as => 'pdf_guide'
  match 'guides/edit/current' => 'guides#edit', :as => 'edit_guide'

  resources :landscapes, :only => [:index]
  resources :species
  resources :entries, :only => [:create, :destroy, :index]

  namespace :admin do
    resources :landscapes
    resources :species, :except => [:show] do
      resources :pictures, :except => [:index, :show]
    end
  end
  
  get "taxonomy" => "taxonomy#index", :as => 'taxonomy', :format => :json
  
  get "search/index", :as => 'search'

  match 'authorizations/create_or_update' => 'authorizations#create_or_update', :as => 'authorizations_create_or_update'
  match 'authorizations' => 'authorizations#index'

end
