require 'rails_helper'

RSpec.feature 'Log in/out and Sign Up', type: :feature do
  scenario 'helpful message on sign up ' do
    sign_up_with('test@test.com', 'password')
    expect(page).to have_content('A helpful message to say you\'ve been signed in!')
  end

  scenario 'can not sign up with invalid email', type: :feature do
    sign_in_with('not an email', 'password')
    expect(page).to have_content('Bad email or password.')
    expect(page).not_to have_content('A helpful message to say you\'ve been signed in! Sign up Email Password Sign in')
  end

  scenario 'Can Log In When Already Signed Up' do
    user = sign_up_with('test@test.com', 'password')
    sign_out
    sign_in_with('test@test.com', 'password')
    expect(page).to have_content(user.email)
  end

  scenario 'Can request password reset email' do
    visit '/passwords/new'
    fill_in 'password_email', with: 'test@test.com'
    click_button 'Reset password'
    expect(page).to have_content('changing your password.')
  end
end
