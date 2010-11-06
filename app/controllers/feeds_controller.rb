class FeedsController < ApplicationController
  session :off
  def sitemap
    @tips = Tip.order("updated_at DESC")
  end

  def latest_tips
    @tips = Tip.order("updated_at DESC")
  end
  
end
