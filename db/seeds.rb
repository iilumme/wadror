b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042

l1 = Style.create name:"Lager"
l2 = Style.create name:"Pale Ale"
l3 = Style.create name:"Porter"
l4 = Style.create name:"Weizen"
l5 = Style.create name:"IPA"

b1.beers.create name:"Iso 3", style_id:1
b1.beers.create name:"Karhu", style_id:1
b1.beers.create name:"Tuplahumala", style_id:1
b2.beers.create name:"Huvila Pale Ale", style_id:2
b2.beers.create name:"X Porter", style_id:3
b3.beers.create name:"Hefeweizen", style_id:4
b3.beers.create name:"Helles", style_id:1