set :application, "handy_rails_tips"
set :deploy_to, "/home/gavin/public_html/handy_rails_tips/"
set :domain,  "handyrailstips.com"

 
role :app, "204.232.194.123"
role :web, "204.232.194.123"
role :db,  "204.232.194.123", :primary => true
 
set :scm, "git"
set :scm_verbose, true 
set :repository,  "git@github.com:GavinM/handy_rails_tips.git"
set :scm_user, "gavinM"
set :scm_passphrase, "1sickpuppy"
 
default_run_options[:pty] = true

set :user, "gavin"
set :runner, user
 
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
 
  task :stop, :roles => :app do
    # Do nothing.
  end
 
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end