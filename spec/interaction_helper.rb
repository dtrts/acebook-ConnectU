require 'support/features/clearance_helpers'

def create_post(message)
  visit('/posts')
  click_button('new-post-button')
  fill_in('post[message]', with: message)
  click_button('Submit')
  Post.order(:id).last
end

def edit_post(message, post_id)
  visit('/posts')
  within("#post-#{post_id}") do
    click_button('Edit Post')
  end
  fill_in('post[message]', with: message)
  click_button('Submit')
end

def delete_post(post_id)
  visit('/posts')
  within("#post-#{post_id}") do
    click_button('delete')
  end
end

def create_wall_post(message, user_id)
  visit("/users/#{user_id}")
  fill_in('post[message]', with: message)
  click_button 'post-submit'
  Post.order(:id).last
end

def create_comment(body, post_id)
  visit('/posts')
  within("#post-#{post_id}") do
    fill_in('comment[body]', with: body)
    click_button('Create Comment')
  end
  Comment.where(post_id: post_id).order(:id).last
end
