require 'rails_helper'

RSpec.feature 'Edit post', type: :feature do
  scenario 'Can edit own post' do
    sign_in
    # user = current_user
    visit '/posts/new'
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

  scenario 'Cannot delete other user post' do
    sign_in
    visit '/posts/new'
    fill_in :"post[message]", with: 'This is a message'
    click_button 'Submit'
    sign_out
    sign_in
    visit '/posts'
    # expect(page).to have_content('Cannot delete another user\'s posts')
    expect(page).not_to have_button('Edit Post')
  end
end
