# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign in users', type: :request do
  let(:password) { SecureRandom.hex(16) }

  context 'An Admin' do
    let(:admin) { FactoryBot.create(:admin_user, password: password) }

    it 'can sign in with valid credentials' do
      post new_admin_user_session_path, params: {
        'admin_user[email]' => admin.email,
        'admin_user[password]' => password
      }

      expect(response.status).to eq(302)
      expect(response.location).to eq(admin_user_root_url)
    end

    context 'without a valid CSRF token' do
      # We're specifically interested in checking the forgery protection in these
      # tests. It's not usually enabled in the test environment so we'll turn it on
      # here.
      before do
        ActionController::Base.allow_forgery_protection = true
      end

      after do
        ActionController::Base.allow_forgery_protection = false
      end

      it 'is rejected' do
        expect do
          post new_admin_user_session_path, params: {
            'admin_user[email]' => admin.email,
            'admin_user[password]' => password
          }
        end.to raise_error(ActionController::InvalidAuthenticityToken)
      end
    end
  end

  context 'A User' do
    let(:user) { FactoryBot.create(:user, password: password) }

    it 'can sign in with valid credentials' do
      post new_user_session_path, params: { 'user[email]' => user.email, 'user[password]' => password }

      expect(response.status).to eq(302)
      expect(response.location).to eq(user_root_url)
    end

    context 'without a valid CSRF token' do
      # We're specifically interested in checking the forgery protection in these
      # tests. It's not usually enabled in the test environment so we'll turn it on
      # here.
      before do
        ActionController::Base.allow_forgery_protection = true
      end

      after do
        ActionController::Base.allow_forgery_protection = false
      end

      it 'is rejected' do
        expect do
          post new_admin_user_session_path, params: { 'user[email]' => user.email, 'user[password]' => password }
        end.to raise_error(ActionController::InvalidAuthenticityToken)
      end
    end
  end

  context 'An Organisation' do
    let(:org) { FactoryBot.create(:organisation_user, password: password) }

    it 'can sign in with valid credentials' do
      post new_organisation_user_session_path, params: {
        'organisation_user[email]' => org.email,
        'organisation_user[password]' => password
      }

      expect(response.status).to eq(302)
      expect(response.location).to eq(organisation_user_root_url)
    end

    context 'without a valid CSRF token' do
      # We're specifically interested in checking the forgery protection in these
      # tests. It's not usually enabled in the test environment so we'll turn it on
      # here.
      before do
        ActionController::Base.allow_forgery_protection = true
      end

      after do
        ActionController::Base.allow_forgery_protection = false
      end

      it 'is rejected' do
        expect do
          post new_organisation_user_session_path, params: {
            'organisation_user[email]' => org.email,
            'organisation_user[password]' => password
          }
        end.to raise_error(ActionController::InvalidAuthenticityToken)
      end
    end
  end
end
