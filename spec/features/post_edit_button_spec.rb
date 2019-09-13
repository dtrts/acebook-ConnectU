require 'rails_helper'

RSpec.feature 'Edit post', type: :feature do
  scenario 'Can edit own post' do
    user = sign_in
    # user = current_user

    visit "/users/#{user.id}/posts/new"
    fill_in :"post[message]", with: 'This is a message'
    click_button 'Submit'
    expect(page).to have_content('This is a message')
    # visit "/users/#{user.id}/posts"
    click_button 'Edit Post'
    fill_in :"post[message]", with: 'This is a better post indeed'
    click_button 'Submit'
    expect(page).to have_content('This is a better post indeed')
    expect(page).to have_content('Post successfully updated')
  end

  scenario 'Cannot edit other user post' do
    user = sign_in
    # user = User.all.order(created_at: :asc).last
    visit "/users/#{user.id}/posts/new"
    fill_in :"post[message]", with: 'This is a message'
    click_button 'Submit'
    sign_out
    sign_in
    visit '/posts'
    expect(page).not_to have_button('Edit Post')
    # click_button 'Edit Post'
    # expect(page).to have_content("Cannot update another user's posts")
  end
end
