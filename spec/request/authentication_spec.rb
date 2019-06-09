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
      expect(response.location).to eq("http://www.example.com#{admin_user_index_path}")
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
      post new_admin_user_session_path, params: { 'user[email]' => user.email, 'user[password]' => password }

      expect(response.status).to eq(302)
      expect(response.location).to eq("http://www.example.com#{user_index_path}")
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
end
