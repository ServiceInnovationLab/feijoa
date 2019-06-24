# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/SharesController', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:birth_records) { FactoryBot.create_list(:birth_record, 3) }
  let!(:target_org) { FactoryBot.create :organisation_user, email: 'rangi@example.com' }
  let(:target_birth_record) do
    FactoryBot.create(
      :birth_record,
      first_and_middle_names: 'Timmy',
      family_name: 'Target-Person',
      date_of_birth: '1979-01-01'
    )
  end
  before do
    user.birth_records << birth_records
    user.birth_records << target_birth_record
  end

  describe 'share a birth record' do
    context 'A User with an associated Birth Records' do
      before { login_as(user, scope: :user) }

      context 'the user chooses to share the birth record' do
        before do
          visit user_birth_records_path
          find(".birth-record[data-id='#{target_birth_record.id}']").click_link('share')

          # wait for destination page to load
          page.has_css?('body.user__shares--new')
        end

        it 'renders the new share page' do
          expect(page).to have_text('Share a document')
          Percy.snapshot(page, name: 'share the birth record')
        end

        it 'shows the selected birth record' do
          expect(page).to have_text(target_birth_record.full_name)
        end
      end
    end
  end

  describe 'View existing shares of my records' do
    before do
      login_as(user, scope: :user)
      visit user_birth_record_path(target_birth_record)
      click_link 'share'
      select 'rangi@example.com', from: 'Recipient'
      click_button 'Share birth record'
      Percy.snapshot(page, name: 'Shared birth record')
    end
    it { expect(page).to have_text 'Share was successfully created.' }
    it { expect(page).to have_text 'Shared with' }
    it { expect(page).to have_text 'rangi@example.com' }
    it { expect(page).to have_link 'revoke' }

    describe 'Revoke consent' do
      before do
        accept_confirm { click_link 'revoke' }
      end
      it { expect(page).to have_text 'Share was successfully destroyed.' }
      it { expect(page).not_to have_text 'Shared with' }
      it { expect(page).not_to have_text 'rangi@example.com' }
      it { expect(page).not_to have_link 'revoke' }
    end
  end
end
