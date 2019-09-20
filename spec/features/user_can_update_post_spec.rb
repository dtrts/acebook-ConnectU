require "rails_helper"

RSpec.feature "Timeline", type: :feature do
  after(:each) do
    travel_back
  end
  scenario "A user cannot input a really long post" do
    sign_in
    create_post("My" * 2001)
    expect(page).to have_content("Your post is too long.")
  end

  scenario "A user cannot update a post to length of > 4000 characters" do
    sign_in
    post = create_post("My")
    edit_post("My" * 2001, post.id)
    expect(page).to have_content("Your post is too long.")
  end

  scenario "Can edit posts and view them" do
    # TODO: add login helper method
    sign_in
    post = create_post("Hello, world!")
    edit_post("Hello, Dream world!", post.id)
    expect(page).to have_content("Hello, Dream world!")
  end

  scenario "Edit Post button redirects after 10 mins" do
    travel_to(Time.local(1994))
    sign_in
    post = create_post("Hello, world!")
    travel_to(Time.local(1994) + 601)
    click_button("Edit Post")
    expect(page).to have_content('You can\'t edit your post after 10 mins foooool, gotta delete it mate')
  end

  scenario "User can't see edit post button after 10 mins" do
    travel_to Time.local(1994)
    sign_in
    post1 = create_post("Hello, world!")
    travel_to Time.local(1994) + 601
    post2 = create_post("Hello, world again!")
    visit("/posts")

    expect(find("#post-#{post2.id}")).to have_button("Edit Post")
    expect(find("#post-#{post1.id}")).not_to have_button("Edit Post")
  end

  scenario "User cannot edit another users posts" do
    user1 = sign_in
    post1 = create_post("User 1s post")
    sign_out
    user2 = sign_in
    visit("/posts/#{post1.id}/edit")
    fill_in("post[message]", with: "Trying to edit post")
    click_button("Submit")
    expect(page).to have_content("You do not own this post.")
    expect(page).to have_content("User 1s post")
  end

  pending "cannot click submit on /posts/id/edit after ten mins"
  pending "cannot make wall posts that are to long"

  scenario "A user cannot edit other peoples posts" do
    sign_in
    visit("/posts")
    click_on "+"
    fill_in "post_message", with: "My new post"
    click_on "Submit"
    sign_out
    visit "/sign_up"
    fill_in "user_email", with: "test@test.com"
    fill_in "user_password", with: "password"
    fill_in "user_username", with: "password"
    click_button "Sign up"
    visit "/posts"
    expect(page).to have_no_button("Edit Post")
  end
end
