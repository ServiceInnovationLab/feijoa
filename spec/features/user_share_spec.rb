# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sharing a document', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:birth_records) { FactoryBot.create_list(:birth_record, 3) }
  let(:immunisation_records) { FactoryBot.create_list(:immunisation_record, 3) }
  let!(:target_org) { FactoryBot.create :organisation, name: 'Plunket' }
  let(:target_birth_record) do
    FactoryBot.create(
      :birth_record, :static_details,
      first_and_middle_names: 'Timmy',
      family_name: 'Target-Person',
      date_of_birth: '1979-01-01'
    )
  end
  let(:target_immunisation_record) do
    FactoryBot.create(:immunisation_record, full_name: 'Timmy Target-Person', date_of_birth: '1990-02-09')
  end
  before do
    travel_to Time.zone.local('2019-01-01') # So Percy visual diffs show the same time
    Faker::Config.random = Random.new(20) # So documents are the same for Percy
    birth_records.each do |birth_record|
      birth_record.add_to(user)
    end
    immunisation_records.each do |immunisation_record|
      immunisation_record.add_to(user)
    end
    target_birth_record.add_to(user)
    target_immunisation_record.add_to(user)
  end
  after do
    travel_back
    Faker::Config.random = nil # So documents are the same for Percy
  end

  describe 'share a birth record' do
    context 'A User with an associated Birth Records' do
      before { login_as(user, scope: :user) }

      context 'the user chooses to share the birth record' do
        before do
          visit user_birth_records_path
          click_link "share-document-BirthRecord-#{target_birth_record.id}"

          # wait for destination page to load
          page.has_css?('body.user__shares--new')
        end

        it 'shows the selected birth record' do
          expect(page).to have_text('Sharing Birth record of Target-Person, Timmy')
          Percy.snapshot(page, name: 'share the birth record')
        end
      end
    end
  end

  describe 'share an immunisation record' do
    context 'A User with an associated immunisation records' do
      before { login_as(user, scope: :user) }

      context 'the user chooses to share the immunisation record' do
        before do
          visit user_dashboard_index_path
          click_link "share-document-ImmunisationRecord-#{target_immunisation_record.id}"

          # wait for destination page to load
          page.has_css?('body.user__shares--new')
        end

        it 'shows the selected immunisation record' do
          expect(page).to have_text(target_immunisation_record.heading)
          Percy.snapshot(page, name: 'share immunisation record')
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
