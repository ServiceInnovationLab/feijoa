# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::OrganisationsController do
  context 'when logged in as admin' do
    before do
      sign_in(FactoryBot.create(:admin_user))
    end
    it 'renders an index of organisations' do
      get :index
      expect(response).to have_http_status(200)
    end
    it 'shows one organisation' do
      organisation = FactoryBot.create(:organisation)
      get :show, params: { id: organisation.id }
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
