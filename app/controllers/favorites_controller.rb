class FavoritesController < ApplicationController  
  def create
    @tip = Tip.find(params[:tip_id])
    @favorite = @current_user.favorites.create! :tip => @tip
    respond_to do |format|
      format.html do
        flash[:notice] = "Tip added to your favorites"
        redirect_to @tip
      end
      format.js {}
    end
  end
  
  def destroy
    @favorite = Favorite.find params[:id]
    @tip = @favorite.tip
    @favorite.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "Tip removed from your favorites"
        redirect_to @tip
      end
      format.js {}
    end
  end
end
