class BeerClub < ActiveRecord::Base
  has_many :memberships, -> {where confirmed: true}
  has_many :unconfirmed_memberships, -> {where confirmed: false}, class_name: "Membership"
  has_many :members, through: :memberships, source: :user
  has_many :unconfirmed, through: :unconfirmed_memberships, source: :user
end
