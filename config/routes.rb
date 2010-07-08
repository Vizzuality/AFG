AFG::Application.routes.draw do |map|

  root :to => "site#home"  
  match 'about' => 'site#about', :as => 'about'
  
  resources :guides, :only => [:index, :show, :update]
  match 'guides/edit/current' => 'guides#edit', :as => 'edit_guide'
    
  resources :species
  resources :entries, :only => [:create, :destroy]
  
  namespace :admin do
    resources :species, :except => [:show] do
      resources :pictures, :except => [:index, :show]
    end
  end

  match 'authorizations/create_or_update' => 'authorizations#create_or_update', :as => 'authorizations_create_or_update'
  match 'authorizations' => 'authorizations#index'

end
