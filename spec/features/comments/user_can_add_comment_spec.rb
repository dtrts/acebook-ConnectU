require 'rails_helper'

RSpec.feature 'Timeline', type: :feature do
  scenario 'Can edit posts and view them' do
    sign_in
    post = create_post('This is a post')
    create_comment('This is a comment', post.id)
    visit('/posts')
    expect(page).to have_content('This is a comment')
  end

  scenario 'A user can see a comments owner' do
    sign_up_with('test@test.com','password','username')
    post = create_post('a post')
    create_comment('This is a comment', post.id)
    visit('/posts')
    expect(page).to have_content('test@test.com')
  end

  scenario 'A user sees a message to let them know the comment was posted successfully' do
    sign_up_with('test@test.com','password','username')
    post = create_post('a post')
    create_comment('This is a comment', post.id)

    expect(page).to have_content('Your comment was posted successfully')

  end
end
