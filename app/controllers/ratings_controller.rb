class RatingsController < ApplicationController
  def index

    Rails.cache.fetch("beer top 3", expires_in: 15.minutes) { @top_beers = Beer.top(3) }
    Rails.cache.fetch("brewery top 3", expires_in: 15.minutes) { @top_breweries = Brewery.top(3) }
    Rails.cache.fetch("user top 3", expires_in: 15.minutes) { @top_users = User.top(3) }
    Rails.cache.fetch("style top 3", expires_in: 15.minutes) { @top_styles = Style.top(3) }
    Rails.cache.fetch("recent rating", expires_in: 15.minutes) { @recent = Rating.recent }

  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end

  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end