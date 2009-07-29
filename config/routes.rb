ActionController::Routing::Routes.draw do |map|
  map.resources :newsletters


  map.root                      :controller => "homepages"
  map.admin       "admin",      :controller => "admin"
  map.my_profile  "my_profile", :controller => "users",     :action => "my_profile"
  map.signup      "signup",     :controller => 'users',     :action => "new"
  map.login       "login",      :controller => "sessions",  :action => "new"
  map.logout      "logout",     :controller => "sessions",  :action => "destroy"
  map.notice      "notice",     :controller => "homepages", :action => "notice"
  map.search      "search",     :controller => "searches",  :action => "show"

  map.with_options :controller => "homepages" do |home|
    home.contribute "contribute",   :action => "contribute"
    home.about       "about",       :action => "about"
    home.terms     "terms_of_use",  :action => "terms"
    home.advertise   "advertise",   :action => "advertise"  
    home.help        "help",        :action => "help"
  end

  map.view_log    "view_log",   :controller => "admin",     :action => "view_log"
  map.clear_log   "clear_log",  :controller => "admin", :action => "clear_log"
  map.backup_log   "backup_log",  :controller => "admin", :action => "backup_log"

  map.with_options :controller => "feeds" do |feeds|
    feeds.sitemap     "sitemap.xml",         :action => "sitemap", :format => :xml
    feeds.rss             "rss",         :action => "latest_tips", :format => :rss
    feeds.comments_feed "comments_feed", :action => "comments", :format => :rss
  end
  
  map.forgot_password 'forgot_password',   :controller => "forgot_password", :action => "index"
  map.login_with_token "login_with_token", :controller => "sessions",        :action => "login_with_token"
  map.reset_password 'reset_password',   :controller => "users",             :action => "reset_password"
  map.change_password 'change_password', :controller => "users",             :action => "change_password" 
  
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  
  map.resources :ads, :collection => {:sort => :post}
  map.resources :comments, :member => {:allow => :get, :remove => :get}, :except => [:edit, :update, :show]
  map.resources :favorites, :collection => {:create => [:get, :post]}
  map.resources :feedbacks, :except => [:edit, :update, :show]
  map.resources :newsletters, :member => {:send_email => :get}
  map.resources :searches, :only => [:create, :index, :destroy]
  map.resources :subscribers, :except => [:edit, :update, :show]
  map.resources :tips, :member => {:flag => :get, :allow => :get, :remove => :get} do |tip|
    tip.resources :comments, :member => {:flag => :get, :allow => :get, :remove => :get}, :except => [:edit, :update, :show]
  end
  map.resources :users, :collection => {:my_profile => :get}
  
  map.connect "robots.txt", :controller => "robots"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
