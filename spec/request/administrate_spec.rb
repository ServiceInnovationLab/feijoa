# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'use Administrate dashboards', type: :request do
  shared_examples 'admin page redirects' do
    describe 'is redirected to the AdminUser login' do
      before { get admin_root_path }
      it { expect(response).to be_redirect }
      it { expect(response.redirect_url).to eq(new_admin_user_session_url) }
    end
  end

  context 'logged in as an admin user' do
    it 'can view the default dashboard' do
      sign_in FactoryBot.create(:admin_user)
      get admin_root_path
      expect(response).to be_successful
    end
  end

  context 'logged in as a normal user' do
    before { sign_in FactoryBot.create(:user) }
    include_examples 'admin page redirects'
  end

  context 'A guest' do
    include_examples 'admin page redirects'
  end
end
