# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Authentication' do
  let(:password) { 'thisisaverylongpasswordindeed' }
  let(:user) { FactoryBot.create(:user, email: 'user@example.com', password: password) }

  context 'A random visitor (not logged in)' do
    it 'can view the home page' do
      visit root_path

      expect(page.current_path).to eq(root_path)
    end

    it 'can view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(new_user_session_path)
      sleep(0.5) # to allow the image to load for Percy snapshot
      Percy.snapshot(page, name: 'user login page')
    end

    it 'can view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(new_user_registration_path)
    end

    it 'is redirected to user sign-in if it tries to open the user page' do
      visit user_index_path

      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  context 'A logged in User' do
    before(:each) do
      visit new_user_session_path
      fill_in :user_email, with: user.email
      fill_in :user_password, with: password
      click_button 'Log in'
    end

    it 'can view the home page' do
      visit root_path

      expect(page.current_path).to eq(root_path)
    end

    it 'is redirected to the user root if it tries to view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(authenticated_user_root_path)
    end

    it 'is redirected to the user root if it tries to view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(authenticated_user_root_path)
    end

    it 'can view the user page' do
      visit user_index_path

      expect(page.current_path).to eq(user_index_path)
      Percy.snapshot(page, name: 'user dashboard')
    end
  end
end
