require 'rails_helper'

RSpec.feature 'User authentication' do
    let!(:user) { create(:user) }

    specify 'can log in with valid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_content('You made it...')
    end

    specify 'cannot log in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('You made it...')
    end
end
