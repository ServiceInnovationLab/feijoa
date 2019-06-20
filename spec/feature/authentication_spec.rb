# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Authentication' do
  let(:password) { 'thisisaverylongpasswordindeed' }
  let(:user) { FactoryBot.create(:user, email: 'user@example.com', password: password) }
  let(:admin) { FactoryBot.create(:admin_user, email: 'admin@example.com', password: password) }
  let(:org) { FactoryBot.create(:organisation_user, email: 'org@example.com') }

  context 'A random visitor (not logged in)' do
    it 'can view the home page' do
      visit root_path

      expect(page.current_path).to eq(root_path)
    end

    it 'can view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(new_user_session_path)
      Percy.snapshot(page, name: 'user login page')
    end

    it 'can view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(new_user_registration_path)
    end

    it 'can view the admin login page' do
      visit new_admin_user_session_path

      expect(page.current_path).to eq(new_admin_user_session_path)
      Percy.snapshot(page, name: 'admin login page')
    end

    it 'is redirected to user sign-in if it tries to open the user page' do
      visit user_index_path

      expect(page.current_path).to eq(new_user_session_path)
    end

    it 'is redirected to admin sign-in if it tries to open the admin page' do
      visit admin_user_index_path

      expect(page.current_path).to eq(new_admin_user_session_path)
      Percy.snapshot(page, name: 'admin dashboard')
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

    it 'is redirected to the user page if it tries to view the admin login page' do
      visit new_admin_user_session_path

      expect(page.current_path).to eq(authenticated_user_root_path)
    end

    it 'is redirected to the user page if it tries to view the admin dashboard page' do
      visit admin_user_index_path

      expect(page.current_path).to eq(authenticated_user_root_path)
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

      expect(page.current_path).to eq(authenticated_admin_user_root_path)
    end

    it 'is redirected to the admin page if it tries to view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(authenticated_admin_user_root_path)
    end

    it 'is redirected to the admin page if it tries to view the user page' do
      visit user_index_path

      expect(page.current_path).to eq(authenticated_admin_user_root_path)
    end

    it 'is redirected to the admin page if it tries to view the admin login page' do
      visit new_admin_user_session_path

      expect(page.current_path).to eq(authenticated_admin_user_root_path)
    end
  end
  context 'A logged in Organisation' do
    before(:each) do
      visit new_organisation_user_session_path
      fill_in :organisation_user_email, with: org.email
      fill_in :organisation_user_password, with: org.password
      click_button 'Log in'

      expect(page.body).to include('Signed in successfully')
    end

    it 'can view the home page' do
      visit root_path

      expect(page.current_path).to eq(root_path)
    end

    it 'is redirected to the org page if it tries to view the user login page' do
      visit new_user_session_path

      expect(page.current_path).to eq(authenticated_organisation_user_root_path)
    end

    it 'is redirected to the org page if it tries to view the user sign-up page' do
      visit new_user_registration_path

      expect(page.current_path).to eq(authenticated_organisation_user_root_path)
    end

    it 'is redirected to the org page if it tries to view the user page' do
      visit user_index_path

      expect(page.current_path).to eq(authenticated_organisation_user_root_path)
    end

    it 'is redirected to the org page if it tries to view the admin login page' do
      visit new_admin_user_session_path

      expect(page.current_path).to eq(authenticated_organisation_user_root_path)
    end
  end
end
