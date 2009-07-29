class FeedsController < ApplicationController
  session :off
  def sitemap
    @tips = Tip.for_public.all :order => "updated_at DESC"
  end

  def latest_tips
    @tips = Tip.for_public.all :order => "updated_at DESC"
  end
  
  def comments
    @tip      = Tip.find(params[:tip_id])
    @comments = @tip.comments.all :order => "created_at DESC"
  end
end
