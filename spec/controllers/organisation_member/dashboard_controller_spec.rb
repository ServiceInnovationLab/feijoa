# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::DashboardController do
  let(:organisation_member) { FactoryBot.create(:organisation_member) }
  let(:user) { organisation_member.user }
  let(:organisation) { organisation_member.organisation }
  let(:other_organisation) { FactoryBot.create(:organisation) }

  before { sign_in user }

  describe 'GET index' do
    it 'shows a dashboard for an organisation the user is part of' do
      get :index, params: { organisation_id: organisation.id }
      expect(assigns(:organisation)).to eq(organisation)
      expect(response).to have_http_status(200)
    end

    it "doesn't show a dashboard for an organisation the user isn't part of" do
      get :index, params: { organisation_id: other_organisation.id }
      expect(response).to redirect_to root_path
    end
  end
end
