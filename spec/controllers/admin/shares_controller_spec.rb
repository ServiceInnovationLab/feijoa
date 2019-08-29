# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SharesController do
  context 'when logged in as admin' do
    before do
      sign_in(FactoryBot.create(:admin_user))
    end
    it 'renders an index of shares' do
      get :index
      expect(response).to have_http_status(200)
    end
    it 'shows one share' do
      share = FactoryBot.create(:share)
      get :show, params: { id: share.id }
      expect(response).to have_http_status(200)
    end
  end
  context 'when logged in as a normal user' do
    before do
      sign_in(FactoryBot.create(:user))
    end
    it 'redirects back to user root' do
      get :index
      expect(response).to have_http_status(302)
    end
  end
  context 'when not logged in' do
    it 'redirects to login' do
      get :index
      expect(response).to have_http_status(302)
    end
  end
end
