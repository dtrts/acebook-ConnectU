require 'rails_helper'

RSpec.feature 'Delete post', type: :feature do
  scenario 'Can delete own post' do
    user = sign_in
    # user = current_user
    visit "/users/#{user.id}/posts/new"
    fill_in :"post[message]", with: 'This is a message'
    click_button 'Submit'
    # visit "/users/#{user.id}/posts"
    click_button 'Delete Post'
    expect(page).to have_content('Post successfully deleted.')
  end

  scenario 'Cannot delete other user post' do
    user = sign_in
    visit "/users/#{user.id}/posts/new"
    fill_in :"post[message]", with: 'This is a message'
    click_button 'Submit'
    sign_out
    sign_in
    visit '/posts'
    # click_button 'Delete Post'
    # expect(page).to have_content("Cannot delete another user's posts")
    expect(page).not_to have_button('Delete Post')
  end
end
