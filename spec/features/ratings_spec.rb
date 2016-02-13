require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end


  it "s page should list ratings" do
    @ratings = Array.new
    @ratings <<  FactoryGirl.create(:rating, score:21, beer:beer1, user:user)
    @ratings <<  FactoryGirl.create(:rating, score:21, beer:beer2, user:user)
    @ratings <<  FactoryGirl.create(:rating, score:5, beer:beer2, user:user)
    visit ratings_path

    expect(page).to have_content "Number of ratings: #{@ratings.count}"
    @ratings.each do |rating|
      expect(page).to have_content rating.score
    end

  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end