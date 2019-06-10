# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Authentication' do
  let(:password) { 'thisisaverylongpasswordindeed' }
  let(:user) { FactoryBot.create(:user, password: password) }
  let(:admin) { FactoryBot.create(:admin_user, password: password) }

  context 'A random visitor (not logged in)' do
    it 'can view the home page' do
      visit root_path

      expect(page.current_path).to eq(root_path)
    end

    it 'can view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(new_user_session_path)
    end

    it 'can view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(new_user_registration_path)
    end

    it 'can view the admin login page' do
      visit new_admin_session_path

      expect(page.current_path).to eq(new_admin_session_path)
    end

    it 'is redirected to user sign-in if it tries to open the user page' do
      visit user_index_path

      expect(page.current_path).to eq(new_user_session_path)
    end

    it 'is redirected to admin sign-in if it tries to open the admin page' do
      visit admin_user_index_path

      expect(page.current_path).to eq(new_admin_session_path)
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

    it 'is redirected to the user index if it tries to view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(user_index_path)
    end

    it 'is redirected to the dashboard if it tries to view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(user_index_path)
    end

    it 'can view the user user page' do
      visit user_index_path

      expect(page.current_path).to eq(user_index_path)
    end

    it 'is redirected to the user page if it tries to view the admin login page' do
      visit new_admin_user_session_path

      expect(page.current_path).to eq(user_index_path)
    end

    it 'is redirected to the user page if it tries to view the admin dashboard page' do
      visit admin_user_index_path

      expect(page.current_path).to eq(user_index_path)
    end
  end

  context 'A logged in Admin' do
    before(:each) do
      visit new_admin_user_session_path
      fill_in :admin_user_email, with: admin.email
      fill_in :admin_user_password, with: password
      click_button 'Log in'

      expect(page.body).to include('Signed in successfully')
    end

    it 'can view the home page' do
      visit root_path

      expect(page.current_path).to eq(root_path)
    end

    it 'is redirected to the admin page if it tries to view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(admin_index_path)
    end

    it 'is redirected to the admin page if it tries to view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(admin_index_path)
    end

    it 'is redirected to the admin page if it tries to view the user page' do
      visit user_index_path

      expect(page.current_path).to eq(admin_index_path)
    end

    it 'is redirected to the admin page if it tries to view the admin login page' do
      visit new_admin_session_path

      expect(page.current_path).to eq(admin_index_path)
    end
  end
end
