class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  validates :username, length: { minimum: 3, maximum: 15 }, uniqueness: true
  validates :password, length: {minimum: 4}, format: {with: /(?=.*\d)(?=.*([A-Z]))/, message: "has to contain one number and one upper case letter"}

  has_secure_password

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite(category)
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end

  private

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
    sorted_by_rating_in_desc_order.take(n)
  end

end








