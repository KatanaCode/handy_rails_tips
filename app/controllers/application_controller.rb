class ApplicationController < ActionController::Base
  
  turn_off_sessions_for_robots
  
  #session_enabled?
  
  ID_ACCT_NO = "f6f857ecb1bf718d7c85b1170bf9bbf8"  
  
  helper :application, :layouts, :tips
  protect_from_forgery :secret => '1283952abc1ff9952ad252a245b35509'
  filter_parameter_logging :password
  before_filter :fetch_current_user
  before_filter :fetch_ads
  #before_filter :new_subscriber using feedburner now
  #before_filter :new_search using google CSE now
  
  helper_method :current_user, :logged_in?, :this_user_logged_in?, :admin_logged_in?, 
                  :flagged_message, :slogan, :add_to_favorites
  
  def logged_in?
    !@current_user.nil?
  end
  
  def admin_logged_in?
    logged_in? ? @current_user.admin? : false
  end
  
  def user_login_required
    unless logged_in?
      flash[:warning] = login_message
      redirect_to notice_url
    end
  end
  
  def this_user_logged_in?(user)
    user == current_user
  end
  
  def this_user_login_required(user)
    unless this_user_logged_in?(user)
      flash[:warning] = no_access_message
      redirect_to notice_url
    end
  end
  
  def admin_login_required
    unless admin_logged_in?
      flash[:warning] = no_access_message
      redirect_to notice_url
    end
  end
  
  def current_user
    @current_user
  end
  
  def saved_msg
    "Your changes were saved"
  end
  def login_message
    "You must log in to view that page"
  end
  
  def no_access_message
    logger.info "No access message called"
    "You don't have access to that page"
  end
  
  def flagged_message(obj)
    "This #{obj} has been flagged for inspection"
  end
  
  def deleted_message(obj)
    "#{obj} was removed from the database"
  end
  
  
  def slogan
    "Ruby On Rails Tips &amp; Tutorials"
   end
  
  protected

  # not used
  # def new_search
  #   @search = Search.new
  # end
  
  # not used
  # def new_subscriber
  #   @subscriber = Subscriber.new
  # end
  
  def fetch_ads
    @ads = Ad.find :all, :order => "rand()"
  end
  
  def fetch_current_user
    
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end
end