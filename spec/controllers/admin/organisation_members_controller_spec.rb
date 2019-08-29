# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::OrganisationMembersController do
  context 'when logged in as admin' do
    before do
      sign_in(FactoryBot.create(:admin_user))
    end
    it 'renders an index of organisation_members' do
      get :index
      expect(response).to have_http_status(200)
    end
    it 'shows one organisation_member' do
      organisation_member = FactoryBot.create(:organisation_member)
      get :show, params: { id: organisation_member.id }
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
