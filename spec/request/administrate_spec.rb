# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'use Administrate dashboards', type: :request do
  context 'An Admin' do
    let(:admin) { FactoryBot.create(:admin_user) }

    it 'can view the default dashboard' do
      sign_in admin
      get admin_root_path

      expect(response).to be_successful
    end
  end

  context 'A User' do
    let(:user) { FactoryBot.create(:user) }

    it 'is redirected to the AdminUser login' do
      sign_in user
      get admin_root_path

      expect(response).to be_redirect
      expect(response.redirect_url).to eq(new_admin_user_session_url)
    end
  end

  context 'An Organisation' do
    let(:org) { FactoryBot.create(:organisation_user) }

    it 'is redirected to the AdminUser login' do
      sign_in org
      get admin_root_path

      expect(response).to be_redirect
      expect(response.redirect_url).to eq(new_admin_user_session_url)
    end
  end

  context 'A guest' do
    it 'is redirected to the AdminUser login' do
      get admin_root_path

      expect(response).to be_redirect
      expect(response.redirect_url).to eq(new_admin_user_session_url)
    end
  end
end
