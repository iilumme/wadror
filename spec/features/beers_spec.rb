require 'rails_helper'

include Helpers

describe "Beer" do

  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")

    @breweries = ["Koff"]
    @breweries.each do |brewery_name|
      FactoryGirl.create(:brewery, name: brewery_name)
    end

  end

  it "when given, is added" do
    visit new_beer_path
    fill_in('beer_name', with:'i')
    select('Koff', from:'beer_brewery_id')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "when given with blank name, is not added" do
    visit new_beer_path
    click_button('Create Beer')

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to be(0)
  end

end