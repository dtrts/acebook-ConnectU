require "rails_helper"

RSpec.feature "UserWallPosts", type: :feature do
  scenario "User can add post and view it on their own wall" do
    user = sign_in
    create_post("My new post")
    visit("/users/#{user.id}")
    expect(page).to have_content("My new post")
  end

  scenario "user sees wall posts on their wall" do
    user = sign_in
    create_wall_post("This is a wall post", user.id)

    visit("/users/#{user.id}")
    expect(page).to have_content("This is a wall post")
    visit("/posts")
    expect(page).not_to have_content("This is a wall post")
  end

  scenario "user makes public post, it appears on their wall" do
    user = sign_in
    create_post("public post for public and wall viewing")
    visit("/posts")
    expect(page).to have_content("public post for public and wall viewing")
    visit("/users/#{user.id}")
    expect(page).to have_content("public post for public and wall viewing")
  end

  scenario "user makes public and wall post" do
    user = sign_in
    visit "/posts"
    create_post("public post for public and wall viewing")
    create_wall_post("This is a wall post", user.id)

    visit("/users/#{user.id}")
    expect(page).to have_content("This is a wall post")
    expect(page).to have_content("public post for public and wall viewing")
    visit("/posts")
    expect(page).not_to have_content("This is a wall post")
    expect(page).to have_content("public post for public and wall viewing")
  end

  scenario "two users at the same time man" do
    user1 = FactoryBot.create(:user, password: "password", username: "user1")
    user2 = FactoryBot.create(:user, password: "password", username: "user2")

    sign_in_with(user1.email, user1.password)
    public_post1 = create_post("public post for public and wall viewing from user the first")
    wall_post_1_2 = create_wall_post("This is a wall post from user 1 to user 2 ", user2.id)

    sign_out
    sign_in_with(user2.email, user2.password)
    public_post2 = create_post("public post for public and wall viewing from user the second")
    wall_post_2_1 = create_wall_post("This is a wall post from user 2 to user 1 ", user1.id)

    visit("/posts")
    expect(page).not_to have_xpath("//div[@id='post-#{wall_post_1_2.id}']")
    expect(page).not_to have_xpath("//div[@id='post-#{wall_post_2_1.id}']")
    expect(page).to have_xpath("//div[@id='post-#{public_post1.id}']")
    expect(page).to have_xpath("//div[@id='post-#{public_post2.id}']")

    visit("/users/#{user1.id}")

    expect(page).not_to have_xpath("//div[@id='post-#{wall_post_1_2.id}']")
    expect(page).to have_xpath("//div[@id='post-#{wall_post_2_1.id}']")
    expect(page).to have_xpath("//div[@id='post-#{public_post1.id}']")
    expect(page).not_to have_xpath("//div[@id='post-#{public_post2.id}']")

    visit("/users/#{user2.id}")

    expect(page).to have_xpath("//div[@id='post-#{wall_post_1_2.id}']")
    expect(page).not_to have_xpath("//div[@id='post-#{wall_post_2_1.id}']")
    expect(page).not_to have_xpath("//div[@id='post-#{public_post1.id}']")
    expect(page).to have_xpath("//div[@id='post-#{public_post2.id}']")
  end
end
