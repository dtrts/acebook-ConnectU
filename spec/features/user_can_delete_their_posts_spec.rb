require 'rails_helper'

RSpec.feature 'Delete posts', type: :feature do
  scenario 'A user can delete their posts' do
    sign_in
    post = create_post('secrets!')
    delete_post(post.id)

    expect(page).to have_content('All right then ,keep your secrets. Post deleted.')
    expect(page).not_to have_content('secrets!')
  end

  scenario 'A user cannot delete other peoples posts' do
    sign_in
    post = create_post('secrets!')
    sign_out
    sign_in
    visit('/posts')
    expect(find("#post-#{post.id}")).to have_no_button('delete')
    expect(find("#post-#{post.id}")).to have_content('secrets!')
  end

  scenario 'user deletes a single post' do
    sign_in
    post1 = create_post('this is the post 1, the first')
    post2 = create_post('this is the second post')
    expect(page).to have_content('this is the post 1, the first')
    expect(page).to have_content('this is the second post')
    delete_post(post1.id)
    expect(page).not_to have_content('this is the post 1, the first')
    expect(page).to have_content('this is the second post')
  end
end
