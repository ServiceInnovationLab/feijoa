# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/SharesController', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:birth_records) { FactoryBot.create_list(:birth_record, 3) }
  let!(:target_org) { FactoryBot.create :organisation, name: 'Plunket' }
  let(:target_birth_record) do
    FactoryBot.create(
      :birth_record, :static_details,
      first_and_middle_names: 'Timmy',
      family_name: 'Target-Person',
      date_of_birth: '1979-01-01'
    )
  end
  before do
    travel_to Time.zone.local('2019-01-01') # So Percy visual diffs show the same time
    birth_records.each do |birth_record|
      AuditedOperationsService.add_birth_record_to_user(birth_record: birth_record, user: user)
    end
    AuditedOperationsService.add_birth_record_to_user(birth_record: target_birth_record, user: user)
  end
  after do
    travel_back
  end

  describe 'share a birth record' do
    context 'A User with an associated Birth Records' do
      before { login_as(user, scope: :user) }

      context 'the user chooses to share the birth record' do
        before do
          visit user_birth_records_path
          click_link "share-record-#{target_birth_record.id}"

          # wait for destination page to load
          page.has_css?('body.user__shares--new')
        end

        it 'shows the selected birth record' do
          expect(page).to have_text(target_birth_record.full_name)
          Percy.snapshot(page, name: 'share the birth record')
        end
      end
    end
  end

  describe 'View existing shares of my records' do
    before do
      login_as(user, scope: :user)
      visit user_birth_record_path(target_birth_record)
      click_link 'Share'
      page.execute_script("document.getElementById('recipient_id').value = '#{target_org.id}'")
      click_button id: 'share-button'
    end
    it 'creates a share' do
      expect(page).to have_text 'Share was successfully created.'
      Percy.snapshot(page, name: 'Shared birth record')
    end
    it { expect(page).to have_text 'Shared with' }
    it { expect(page).to have_text 'Plunket' }
    it { expect(page).to have_link 'Revoke' }

    describe 'Revoke consent' do
      before do
        accept_confirm { click_link 'Revoke' }
      end
      it { expect(page).to have_text 'Share was successfully revoked.' }
      it { expect(page).not_to have_text 'Shared with' }
      it { expect(page).not_to have_text 'Plunket' }
      it { expect(page).not_to have_link 'Revoke' }
    end
  end
end
