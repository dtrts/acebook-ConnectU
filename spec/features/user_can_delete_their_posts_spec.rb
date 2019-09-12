require 'rails_helper'

RSpec.feature 'Delete posts', type: :feature do
  scenario 'A user can delete their posts' do
    sign_in

    visit('/posts')
    click_link 'New Post'
    fill_in 'post_message', with: 'My new post'
    click_on 'Submit'
    click_button 'delete'

    expect(page).not_to have_content('My new post')
  end
end
