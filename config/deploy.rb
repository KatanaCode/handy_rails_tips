set :application, "handy_rails_tips"
set :user, "root"
set :runner, user

set :port, 9021

set :deploy_to, "/var/www/handy_rails_tips/"
set :domain,  "handyrailstips.com"

role :app, "178.79.136.234"
role :web, "178.79.136.234"
role :db,  "178.79.136.234", :primary => true

ssh_options[:paranoid]    = false 
ssh_options[:port]        = 9021
default_run_options[:pty] = true 


set :scm, "git"
set :scm_verbose, true 
set :repository,  "git@github.com:GavinM/handy_rails_tips.git"
set :scm_user, "gavinM"
set :scm_passphrase, "1sickpuppy"


namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
 
  task :stop, :roles => :app do
  end
 
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end