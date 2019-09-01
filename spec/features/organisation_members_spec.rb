# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'acting on behalf of an organisation', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:organisation) { FactoryBot.create(:organisation, name: 'Example Org') }
  let!(:organisation_member) { FactoryBot.create(:organisation_member, organisation: organisation, user: user) }

  before do
    login_as(user, scope: :user)
  end

  context 'viewing the dashboard' do
    let!(:revoked_share) { FactoryBot.create(:share, :revoked, recipient: organisation) }
    let!(:unrevoked_share) { FactoryBot.create(:share, recipient: organisation) }
    let!(:new_request) { FactoryBot.create(:request, requester: organisation) }
    let!(:received_request) { FactoryBot.create(:request, :received, requester: organisation) }
    let!(:resolved_request) { FactoryBot.create(:request, :resolved, requester: organisation) }
    let!(:cancelled_request) { FactoryBot.create(:request, :cancelled, requester: organisation) }
    let!(:declined_request) { FactoryBot.create(:request, :declined, requester: organisation) }
    it 'shows unrevoked shares' do
      visit organisation_member_dashboard_path(organisation)
      expect(page).to have_content(unrevoked_share.document.heading)
      expect(page).not_to have_content(revoked_share.document.heading)
    end
    it 'shows unresolved requests' do
      visit organisation_member_dashboard_path(organisation)
      expect(page).to have_content("Requested from #{new_request.requestee.email}")
      expect(page).to have_content("Requested from #{received_request.requestee.email}")
      expect(page).not_to have_content("Requested from #{resolved_request.requestee.email}")
      expect(page).not_to have_content("Requested from #{cancelled_request.requestee.email}")
      expect(page).not_to have_content("Requested from #{declined_request.requestee.email}")
    end
  end
end
