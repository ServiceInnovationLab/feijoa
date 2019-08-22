# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sending a request from an organisation', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:organisation) { FactoryBot.create(:organisation, name: 'Example Org') }
  let!(:organisation_member) { FactoryBot.create(:organisation_member, organisation: organisation, user: user) }

  before { login_as(user, scope: :user) }

  context 'when a user is acting on behalf of an organisation' do
    before do
      visit new_organisation_member_request_path(organisation_id: organisation.id)
      fill_in 'Note', with: 'A note'
      select 'Birth record', from: 'Document type'
    end

    it 'requires email address' do
      email_field = find_field('Requestee email')
      expect(email_field[:required]).to eq('true')
    end

    context 'when an email address is provided' do
      it 'saves the current organisation as the requester' do
        fill_in 'Requestee email', with: 'user@example.com'
        click_button 'Create Request'
        expect(page).to have_content('Request for a document to be shared with Example Org')
      end
    end

    context 'cancelling the request' do
      before do
        fill_in 'Requestee email', with: 'user@example.com'
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
      visit new_organisation_member_request_path(organisation_id: organisation.id)
      fill_in 'Note', with: 'A note'
      select 'Birth record', from: 'Document type'
      fill_in 'Requestee email', with: recipient.email
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
      expect(page).to have_content('Example Org')
      expect(page).to have_content('A note')
      expect(page).to have_content('Birth record')
    end

    it 'marks the request as received when the recipient views it' do
      visit user_requests_path
      click_link 'View'
      expect(page).to have_content('received')
    end
  end
end
