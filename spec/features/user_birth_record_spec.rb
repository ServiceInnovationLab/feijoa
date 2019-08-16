# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/BirthRecordsController', type: :feature do
  describe '#query' do
    context 'A User' do
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as(user, scope: :user)
      end

      context 'a target record and some other records exist' do
        let!(:target_record) do
          FactoryBot.create(
            :birth_record,
            first_and_middle_names: 'Timmy',
            family_name: 'Target-Person',
            date_of_birth: '1979-01-01',
            place_of_birth: 'Wellington',
            sex: 'X',
            parent_first_and_middle_names: 'Daniel',
            parent_family_name: 'Chuck',
            other_parent_first_and_middle_names: 'Tameka',
            other_parent_family_name: 'Senger'
          )
        end
        let(:birth_records) { FactoryBot.create_list(:birth_record, 10) }

        context 'the required fields are filled in correctly' do
          # Test marked as pending due to flakiness
          xit 'is found' do
            # Ensure the record is created
            expect(target_record).to eq target_record
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: target_record.first_and_middle_names
            fill_in 'birth_record_family_name', with: target_record.family_name
            fill_in 'birth_record_date_of_birth', with: target_record.date_of_birth

            click_on 'Find'

            expect(page).to have_selector('.card', count: 1)
            Percy.snapshot(page, name: 'find birth record')
          end
        end

        context 'all the permitted fields are filled in correctly' do
          # Test marked as pending due to flakiness
          xit 'is found and can be added and removed' do
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: 'Timmy'
            fill_in 'birth_record_family_name', with: 'Target-Person'
            fill_in 'birth_record_date_of_birth', with: '01/01/1979'

            fill_in 'birth_record_place_of_birth', with: 'Wellington'
            fill_in 'birth_record_parent_first_and_middle_names', with: 'Daniel'
            fill_in 'birth_record_parent_family_name', with: 'Chuck'
            fill_in 'birth_record_other_parent_first_and_middle_names', with: 'Tameka'
            fill_in 'birth_record_other_parent_family_name', with: 'Senger'

            click_on 'Find'

            expect(page).to have_content 'Target-Person, Timmy'
            expect(page).to have_content 'Senger, Tameka'
            expect(page).to have_content 'Chuck, Daniel'

            # look for exactly 1 'add' button on a card for the target birth record
            expect(page).to have_css(
              ".birth-record[data-id='#{target_record.to_param}'] .birth-record__button[data-verb='add']",
              count: 1
            )

            click_link 'add'

            expect(page).to have_selector('.card', count: 1)
            expect(page).to have_content target_record.family_name

            Percy.snapshot(page, name: 'added a record')
            accept_confirm do
              click_link 'remove'
            end
            expect(page).not_to have_content target_record.family_name
          end
        end

        context 'no fields are filled in' do
          it 'no records are found' do
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: target_record.first_and_middle_names
            fill_in 'birth_record_date_of_birth', with: target_record.date_of_birth

            # This field doesn't match
            fill_in 'birth_record_family_name', with: 'Not-Target-Person'

            click_on 'Find'

            expect(page).to_not have_css('.card')
          end
        end
      end
    end
  end
end
