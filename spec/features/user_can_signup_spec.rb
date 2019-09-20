require "rails_helper"

RSpec.feature "Log in/out and Sign Up", type: :feature do
  scenario "helpful message on sign up " do
    sign_up_with("test@test.com", "password", "username")
    expect(page).to have_content('A helpful message to say you\'ve been signed in!')
  end

  scenario "can not sign up with invalid email", type: :feature do
    sign_in_with("not an email", "password")
    expect(page).to have_content("Bad email or password.")
    expect(page).not_to have_content('A helpful message to say you\'ve been signed in! Sign up Email Password Sign in')
  end

  scenario "Can Log In When Already Signed Up" do
    user = sign_up_with("test@test.com", "password", "username")
    sign_out
    sign_in_with("test@test.com", "password")
    expect(page).to have_content(user.email)
  end

  scenario "Can request password reset email" do
    visit "/passwords/new"
    fill_in "password_email", with: "test@test.com"
    click_button "Reset password"
    expect(page).to have_content("changing your password.")
  end

  scenario "User can't sign up without supplying username" do
    sign_up_with("test@test.com", "password", "")
    expect(page).to have_content("You must enter a username to signup!")
  end

  scenario "User cannot signup with the already taken username" do
    sign_up_with("test@test.com", "password", "username")
    sign_out
    visit(sign_up_path)
    fill_in("user_email", with: "test1@test.com")
    fill_in("user_password", with: "password")
    fill_in("user_username", with: "username")
    click_button "Sign up"
    expect(page).to have_content("Username already taken!")
  end

  scenario "User cannot sign up with a username that isn't alphanumeric" do
    visit(sign_up_path)
    fill_in("user_email", with: "test1@test.com")
    fill_in("user_password", with: "password")
    fill_in("user_username", with: "username!!!!")
    click_button "Sign up"
    expect(page).to have_content("Your username can only include alphabetical characters and numbers :(")
  end
end
