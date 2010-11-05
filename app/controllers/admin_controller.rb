class AdminController < ApplicationController
  before_filter :admin_login_required
  skip_before_filter :fetch_ads, :only => [:clear_log]
  skip_before_filter :fetch_ads, :only => [:clear_log]
  skip_before_filter :new_subscriber, :only => [:clear_log]
  skip_before_filter :new_search, :only => [:clear_log]
    
  def show
    @tips = Tip.all
  end
  
  def view_log
    @log_content  =   File.read(LOG_PATH) 
    size          =   File.size?(LOG_PATH).to_f/1048576 #converts file size to MB  
    @log_size     =   "%0.3f" % size + " MB"
  end
  
  def clear_log
    File.open(LOG_PATH, "wb") { |file| file.write "Log cleared at #{Time.now} by #{current_user.username}"}
    redirect_to view_log_url
  end
  
  def backup_log
    send_file LOG_PATH, :type => "text/txt",  :stream => false, :filename => "log_backup_#{Date.today}"
  end
end
