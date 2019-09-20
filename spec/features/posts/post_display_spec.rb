require 'rails_helper'

describe 'Post Index' do
  before do
    travel_to Time.local(1994) + 3600
  end

  after do
    travel_back
  end

  it 'can have the time the post was created ' do
    sign_in
    visit '/posts'
    click_button '+'
    fill_in 'post[message]', with: 'This is a new post'
    click_button 'Submit'
    expect(page).to have_content('12:00 AM, 01 of January')
  end

  it 'displays the newest post first' do
    sign_in
    visit '/posts'
    click_button '+'
    fill_in 'post[message]', with: 'This is a new post'
    click_button 'Submit'
    travel_to Time.local(1995)
    click_button '+'
    fill_in 'post[message]', with: 'Hello'
    click_button 'Submit'
    post = Post.order('created_at DESC')
    expect(post[0].message).to eq('Hello')
  end

  it 'can have new lines being displayed' do
    sign_in
    visit '/posts'
    click_button '+'
    fill_in 'post[message]', with: "This\nis\na\nnew\npost"
    click_button 'Submit'
    expect(page).to have_content("This\nis\na\nnew\npost")
  end
end
