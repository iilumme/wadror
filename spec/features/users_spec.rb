require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryGirl.create :user }

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  describe "who has signed in" do

    before :each do

      @brewery = FactoryGirl.create :brewery, name:"Hesan brewery"
      style1 = FactoryGirl.create :style, name:"Lager"
      style2 = FactoryGirl.create :style, name:"IPA"
      style3 = FactoryGirl.create :style, name:"Stout"
      other_brewery = FactoryGirl.create :brewery
      create_beers_with_ratings(user, style1, other_brewery, 10, 20, 15)
      create_beers_with_ratings(user, style2, @brewery, 25, 20)
      create_beers_with_ratings(user, style3, other_brewery, 20, 23, 22)

      visit user_path(user)
    end

    it "the favorite style is shown at user's page" do
      expect(page).to have_content 'preferred style IPA'
    end

    it "the favorite brewery is shown at user's page" do
      expect(page).to have_content 'favorite brewery Hesan brewery'
    end

    it "sees own ratings" do
      expect(user.ratings.count).to eq(8)
      user.ratings.each do |r|
        expect(page).to have_content r.score
      end
    end

  end

end