require 'rails_helper'

RSpec.feature 'Timeline', type: :feature do
  after(:each) do
    travel_back
  end

  scenario 'Can edit posts and view them' do
    # TODO: add login helper method
    sign_in
    post = create_post('Hello, world!')
    edit_post('Hello, Dream world!', post.id)
    expect(page).to have_content('Hello, Dream world!')
  end

  scenario 'Edit Post button redirects after 10 mins' do
    travel_to(Time.local(1994))
    sign_in
    post = create_post('Hello, world!')
    travel_to(Time.local(1994) + 601)
    click_button('Edit Post')
    expect(page).to have_content('You can\'t edit your post after 10 mins foooool, gotta delete it mate')
  end

  scenario "User can't see edit post button after 10 mins" do
    travel_to Time.local(1994)
    sign_in
    post1 = create_post('Hello, world!')
    travel_to Time.local(1994) + 601
    post2 = create_post('Hello, world again!')
    visit('/posts')

    expect(find("#post-#{post2.id}")).to have_button('Edit Post')
    expect(find("#post-#{post1.id}")).not_to have_button('Edit Post')
  end

  scenario 'A user cannot edit other peoples posts' do
    sign_in
    visit('/posts')
    click_on '+'
    fill_in 'post_message', with: 'My new post'
    click_on 'Submit'
    sign_out
    visit '/sign_up'
    fill_in 'user_email', with: 'test@test.com'
    fill_in 'user_password', with: 'password'
    click_button 'Sign up'
    visit '/posts'
    expect(page).to have_no_button('Edit Post')
  end
end
