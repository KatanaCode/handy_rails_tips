class RobotsController < ApplicationController
  session :off
  
  skip_before_filter :fetch_current_user, :fetch_ads
  
  def index
  end

  
end
