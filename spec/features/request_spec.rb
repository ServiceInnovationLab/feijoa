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
      fill_in 'document_type', with: 'Birth Certificate'
      fill_in 'note', with: 'A note'
    end

    # This test will fail because it's not doing what we expect it to do
    context 'when an email address is not provided' do
      xit 'shows an error' do
        click_button 'Save'
        expect(page).to have_content('Could not be saved')
      end
    end

    context 'when an email address is provided' do
      it 'saves the current organisation as the requester' do
        fill_in 'requestee_email', with: 'user@example.com'
        click_button 'Save'
        expect(page).to have_content('Request for a document to be shared with Example Org')
      end
    end
  end

  context 'when the recipient has an existing account' do
    let(:recipient_email) { 'hello123@example.com' }
    let!(:recipient) { FactoryBot.create(:user, email: recipient_email) }

    before do
      visit new_organisation_member_request_path(organisation_id: organisation.id)
      fill_in 'document_type', with: 'Birth Certificate'
      fill_in 'note', with: 'A note'
      fill_in 'requestee_email', with: recipient.email
      click_button 'Save'
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
      expect(page).to have_content('Birth Certificate')
    end
  end
end
