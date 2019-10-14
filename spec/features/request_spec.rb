# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sending a request from an organisation', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:organisation) { FactoryBot.create(:organisation, name: 'Example Org') }
  let!(:organisation_member) { FactoryBot.create(:organisation_member, organisation: organisation, user: user) }

  before do
    travel_to Time.zone.local('2019-01-01') # So Percy visual diffs show the same time
  end

  context 'when a user is acting on behalf of an organisation' do
    before do
      login_as(user, scope: :user)
      visit new_organisation_member_request_path(organisation_id: organisation.id)
      fill_in 'Note', with: 'A note'
      select 'Birth record', from: 'Document type'
    end

    it 'requires email address' do
      email_field = find_field('Recipient')
      expect(email_field[:required]).to eq('true')
    end

    context 'when an email address is provided' do
      it 'saves the current organisation as the requester' do
        fill_in 'Recipient', with: 'user@example.com'
        click_button 'Create Request'
        expect(page).to have_content('Request for a document to be shared with Example Org')
        Percy.snapshot(page, name: 'organisation request show')
      end
    end

    context 'cancelling the request' do
      before do
        fill_in 'Recipient', with: 'user@example.com'
        click_button 'Create Request'
        click_button 'Cancel'
      end
      it 'shows that the request has been cancelled' do
        expect(page).to have_content('cancelled')
      end
      it 'no longer has a cancel button' do
        expect(page).not_to have_button('Cancel')
      end
    end
  end

  context 'when the recipient has an existing account' do
    let(:recipient_email) { 'hello123@example.com' }
    let!(:recipient) { FactoryBot.create(:user, email: recipient_email) }

    before do
      login_as(user, scope: :user)
      visit new_organisation_member_request_path(organisation_id: organisation.id)
      fill_in 'Note', with: 'A note'
      select 'Birth record', from: 'Document type'
      fill_in 'Recipient', with: recipient.email
      click_button 'Create Request'
      expect(page).to have_content('Request for a document to be shared with Example Org')
      click_link 'Log out'
      login_as(recipient, scope: :user)
    end

    it "shows a badge on the recipient's header bar when they log in" do
      visit '/'
      expect(page).to have_content('Requests 1')
    end
    it "shows details of the request on the recipient's request page" do
      visit user_requests_path
      Percy.snapshot(page, name: 'user request index')
      expect(page).to have_content('Example Org')
      expect(page).to have_content('A note')
      expect(page).to have_content('Birth Record')
    end

    it 'marks the request as received when the recipient views it' do
      visit user_requests_path
      click_link 'Request for Birth Record'
      expect(page).to have_content('received')
      Percy.snapshot(page, name: 'user request show')
    end

    context 'the user responding to the request' do
      let(:birth_record) { FactoryBot.create(:birth_record, :static_details) }
      before do
        FactoryBot.create(:user_document, user: recipient, document: birth_record)
        recipient.reload
      end
      it 'marks the request as received when the recipient views it' do
        visit user_requests_path
        click_link 'Request for Birth Record'
        expect(page).to have_content('received')
        Percy.snapshot(page, name: 'user request show')
      end
      it 'brings up documents matching the requested document type' do
        visit user_requests_path
        click_link 'Respond'
        expect(page).to have_content(birth_record.heading)
        Percy.snapshot(page, name: 'user request respond')
      end
      it 'brings up documents matching the requested document type' do
        visit user_requests_path
        click_link 'Respond'
        click_button 'Share'
        expect(page).to have_content(birth_record.heading)
        expect(page).to have_content('resolved')
        Percy.snapshot(page, name: 'user request show with response')
      end
    end
  end
  context 'when the document has been revoked before' do
    let(:birth_record) { FactoryBot.create(:birth_record, :static_details) }
    let(:recipient) { FactoryBot.create(:user) }

    before do
      FactoryBot.create(:user_document, user: recipient, document: birth_record)
      first_share = birth_record.share_with(recipient: organisation, user: user)
      first_share.revoke
      FactoryBot.create(:request, requestee: recipient, requester: organisation)

      login_as(recipient, scope: :user)
      visit user_requests_path
      click_link 'Respond'
      click_button 'Share'
    end

    it 'allows the request recipient to share it again' do
      expect(page).to have_content(birth_record.heading)
      expect(page).to have_content('resolved')
    end

    it 'allows the requester to view the document' do
      click_link 'Log out'
      login_as(user, scope: :user)
      visit organisation_member_dashboard_path(organisation)
      expect(page).to have_content(birth_record.heading)
      expect(page).to have_content("Shared by #{recipient.email}")
      click_link('View')
      expect(page).to have_content(birth_record.date_of_birth)
    end
  end
end
