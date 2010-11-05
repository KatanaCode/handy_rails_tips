HandyRailsTips::Application.routes.draw do

  resource :admin, :only => [:show], :controller => "admin"
  resources :sessions, :except => [:index, :show, :edit, :update]
  resources :tips

  match "sitemap"    => "feeds#sitemap",     :as => "sitemap"
  match "rss"        => "feeds#latest_tips", :as => "rss"    

  match "about" => "homepages#about", :as => "about"
  
  match "robots"     => "robots#index"
  match "javascripts/update_tip" => "javascripts#update_tip"
  
  root :controller => "homepages", :action => "index"
end
