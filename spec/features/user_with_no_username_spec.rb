require 'rails_helper'

RSpec.feature 'UserNoUsername', type: :feature do
  scenario 'user logs in and with no username gives message' do 
    sign_in
    expect(page).to have_content('You need to add a username')
  end
end
