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
        let(:target_record) { FactoryBot.create(:birth_record, family_name: 'Target-Person') }
        let(:birth_records) { FactoryBot.create_list(:birth_record, 10) }

        context 'the required fields are filled in correctly' do
          it 'is found' do
            visit find_user_birth_records_path
            fill_in 'birth_record_first_and_middle_names', with: target_record.first_and_middle_names
            fill_in 'birth_record_family_name', with: target_record.family_name
            fill_in 'birth_record_date_of_birth', with: target_record.date_of_birth

            click_on 'Find'

            expect(page).to have_selector('.card', count: 1)
            expect(page).to have_css("##{target_record.model_name.param_key}--#{target_record.primary_key_string}")
          end
        end

        context 'all the permitted fields are filled in correctly' do
          it 'is found' do
            visit find_user_birth_records_path
            fill_in 'birth_record_first_and_middle_names', with: target_record.first_and_middle_names
            fill_in 'birth_record_family_name', with: target_record.family_name
            fill_in 'birth_record_date_of_birth', with: target_record.date_of_birth

            fill_in 'birth_record_place_of_birth', with: target_record.place_of_birth
            fill_in 'birth_record_parent_first_and_middle_names', with: target_record.parent_first_and_middle_names
            fill_in 'birth_record_parent_family_name', with: target_record.parent_family_name
            fill_in 'birth_record_other_parent_first_and_middle_names', with: target_record.other_parent_first_and_middle_names
            fill_in 'birth_record_other_parent_family_name', with: target_record.other_parent_family_name

            click_on 'Find'

            expect(page).to have_selector('.card', count: 1)
            expect(page).to have_css("##{target_record.model_name.param_key}--#{target_record.primary_key_string}")
          end
        end

        context 'no fields are filled in' do
          it 'no records are found' do
            visit find_user_birth_records_path
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
