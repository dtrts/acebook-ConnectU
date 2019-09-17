require 'rails_helper'

RSpec.feature "UserWalls", type: :feature do
  pending "add some scenarios (or delete) #{__FILE__}"

  after(:each) do
    travel_back
  end 

  scenario "ordering the post by the newest one" do
    user = sign_in
    travel_to Time.local(1994)
    visit("/users/#{user.id}")
    click_button "New Post"
    fill_in 'Message', with: "Hi"
    click_button 'Submit'
    travel_to Time.local(1995)
    p Time.now
    click_button "New Post"
    fill_in 'Message', with: "Hello"
    click_button 'Submit'
    visit("users/#{user.id}")
    p page.body
    expect(find(:xpath, '//div[@id="post-container"][1]')).to have_content("Hello")
     expect(find(:xpath, '//div[@id="post-container"][2]')).to have_content("Hi")

  end 



end
