# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::DashboardController do
  let(:organisation_member) { FactoryBot.create(:organisation_member) }
  let(:user) { organisation_member.user }
  let(:organisation) { organisation_member.organisation }

  before do
    sign_in user
  end

  describe 'GET index' do
    it 'shows a dashboard for an organisation the user is part of' do
      get :index, params: { organisation_id: organisation.id }
      expect(response).to have_http_status(200)
    end
    it "doesn't show a dashboard for an organisation the user isn't part of" do
      other_organisation = FactoryBot.create(:organisation)
      expect do
        get :index, params: { organisation_id: other_organisation.id }
      end.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
