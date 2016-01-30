class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average_rating
    return ratings.average(:score)
  end

  def to_s
    "#{name},  #{brewery.name}"
  end

end
