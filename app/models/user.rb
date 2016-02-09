class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  validates :username, length: { minimum: 3, maximum: 15 }, uniqueness: true
  validates :password, length: {minimum: 4}, format: {with: /(?=.*\d)(?=.*([A-Z]))/, message: "has to contain one number and one upper case letter"}

  has_secure_password
end
