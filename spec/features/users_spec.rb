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

    let!(:user2) { FactoryGirl.create :user, username:"ToinenHeppu" }
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:brewery2) { FactoryGirl.create :brewery, name:"Hesan brewery" }
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:"Lager" }
    let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style:"IPA"  }
    let!(:beer3) { FactoryGirl.create :beer, name:"Seko", brewery:brewery2, style:"IPA"  }
    let!(:rating1) { FactoryGirl.create :rating, score:21, beer:beer1, user:user }
    let!(:rating2) { FactoryGirl.create :rating, score:5, beer:beer1, user:user2 }
    let!(:rating3) { FactoryGirl.create :rating, score:29, beer:beer2, user:user }
    let!(:rating4) { FactoryGirl.create :rating, score:7, beer:beer2, user:user2 }
    let!(:rating5) { FactoryGirl.create :rating, score:40, beer:beer3, user:user }

    before :each do
      sign_in(username:"Pekka", password:"Foobar1")
      visit user_path(user)
    end

    it "sees own ratings" do
      expect(user.ratings.count).to eq(3)
      user.ratings.each do |r|
        expect(page).to have_content r.score
      end
    end

    it "can delete a rating" do
      page.find('li', :text => 'iso 3').click_link('delete')
      expect(user.ratings.count).to eq(2)
    end

    it "sees the favorite beer style" do
      expect(page).to have_content "IPA"
    end

    it "sees the favorite brewery" do
      expect(page).to have_content "Hesan brewery"
    end

  end

end
