require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "is saved when has the username and the style set" do
    beer = Beer.create name:"Testi", style_id:1

    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style_id:1

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Testi"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end