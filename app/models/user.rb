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
    return nil if ratings.empty?

    styles = Hash.new

    ratings.each do |r|
      if styles.has_key?(r.beer.style) == false
        styles[r.beer.style] = Array.new
      end
      array = styles[r.beer.style]
      array << r.score
    end

    averages = Hash.new

    styles.each_pair do |p|
      averages[p[0]] = p[1].sum / p[1].size.to_f
    end

    averages.max { |a, b| a[1] <=> b[1]}[0]

  end

  def favorite_brewery
    return nil if ratings.empty?

    brewerys = Hash.new

    ratings.each do |r|
      if brewerys.has_key?(r.beer.brewery.name) == false
        brewerys[r.beer.brewery.name] = Array.new
      end
      array = brewerys[r.beer.brewery.name]
      array << r.score
    end

    averages = Hash.new

    brewerys.each_pair do |p|
      averages[p[0]] = p[1].sum / p[1].size.to_f
    end

    averages.max { |a, b| a[1] <=> b[1]}[0]

  end
end