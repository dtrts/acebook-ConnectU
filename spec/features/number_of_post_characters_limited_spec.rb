require 'rails_helper'

RSpec.feature 'The number of characters in a post is limited', type: :feature do
  scenario 'A user cannot input a really long post' do
    sign_in
    create_post('My' * 2001)
    expect(page).to have_content('Your post is too long.')
  end

  scenario 'A user cannot update a post to length of > 4000 characters' do
    sign_in
    post = create_post('My')
    edit_post('My' * 2001, post.id)
    expect(page).to have_content('Your post is too long.')
  end
end
