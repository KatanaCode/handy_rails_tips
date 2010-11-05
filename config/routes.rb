HandyRailsTips::Application.routes.draw do

  resource :session, :only => [:new, :create, :destroy]
  resources :tips
  resource :about, :only => [:show], :controller => "about"

  match "sitemap"    => "feeds#sitemap",     :as => "sitemap"
  match "rss"        => "feeds#latest_tips", :as => "rss"    

  match "about" => "homepages#about", :as => "about"
  
  match "robots"     => "robots#index"
  match "javascripts/update_tip" => "javascripts#update_tip"
  
  root :controller => "tips", :action => "index"
end