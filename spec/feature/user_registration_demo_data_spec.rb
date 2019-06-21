# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/registrations_controller', type: :feature do
  describe '#create' do
    context 'A User' do
      let(:user) { FactoryBot.build(:user, email: 'first.last@example.com') }

      context 'after the user registers' do
        before do
          visit new_user_registration_path

          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: user.password
          fill_in 'user_password_confirmation', with: user.password

          click_on 'Sign up'
        end

        it 'can find their own demo birth certificate' do
          visit user_birth_records_path
          click_link 'Search for Birth Record'
          fill_in 'birth_record_first_and_middle_names', with: 'First'
          fill_in 'birth_record_family_name', with: 'Last'
          fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_ADULT_BIRTHDAY

          click_on 'Find'

          # look for exactly 1 match, we don't know the record ID though
          expect(page).to have_css(
            '.birth-record',
            count: 1
          )
        end

        it 'can find a partner\'s demo birth certificate' do
          visit user_birth_records_path
          click_link 'Search for Birth Record'
          fill_in 'birth_record_first_and_middle_names', with: 'Matua'
          fill_in 'birth_record_family_name', with: 'Last'
          fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_ADULT_BIRTHDAY

          click_on 'Find'

          # look for exactly 1 match, we don't know the record ID though
          expect(page).to have_css(
            '.birth-record',
            count: 1
          )
        end

        it 'can find a child\'s demo birth certificate' do
          visit user_birth_records_path
          click_link 'Search for Birth Record'
          fill_in 'birth_record_first_and_middle_names', with: 'Tama'
          fill_in 'birth_record_family_name', with: 'Last'
          fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_CHILD_BIRTHDAY

          click_on 'Find'

          # look for exactly 1 match, we don't know the record ID though
          expect(page).to have_css(
            '.birth-record',
            count: 1
          )
        end

        it 'can find another child\'s demo birth certificate' do
          visit user_birth_records_path
          click_link 'Search for Birth Record'
          fill_in 'birth_record_first_and_middle_names', with: 'Hine'
          fill_in 'birth_record_family_name', with: 'Last'
          fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_CHILD_BIRTHDAY

          click_on 'Find'

          # look for exactly 1 match, we don't know the record ID though
          expect(page).to have_css(
            '.birth-record',
            count: 1
          )
        end
      end

      context 'A User with no obvious family name' do
        let(:user) { FactoryBot.build(:user, email: 'first@example.com') }

        context 'after the user registers' do
          before do
            visit new_user_registration_path

            fill_in 'user_email', with: user.email
            fill_in 'user_password', with: user.password
            fill_in 'user_password_confirmation', with: user.password

            click_on 'Sign up'
          end

          it 'can find their own demo birth certificate with family name Whanau' do
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: 'First'
            fill_in 'birth_record_family_name', with: 'Whanau'
            fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_ADULT_BIRTHDAY

            click_on 'Find'

            # look for exactly 1 match, we don't know the record ID though
            expect(page).to have_css(
              '.birth-record',
              count: 1
            )
          end

          it 'can find a partner\'s demo birth certificate with family name Whanau' do
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: 'Matua'
            fill_in 'birth_record_family_name', with: 'Whanau'
            fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_ADULT_BIRTHDAY

            click_on 'Find'

            # look for exactly 1 match, we don't know the record ID though
            expect(page).to have_css(
              '.birth-record',
              count: 1
            )
          end

          it 'can find a child\'s demo birth certificate with family name Whanau' do
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: 'Tama'
            fill_in 'birth_record_family_name', with: 'Whanau'
            fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_CHILD_BIRTHDAY

            click_on 'Find'

            # look for exactly 1 match, we don't know the record ID though
            expect(page).to have_css(
              '.birth-record',
              count: 1
            )
          end

          it 'can find another child\'s demo birth certificate with family name Whanau' do
            visit user_birth_records_path
            click_link 'Search for Birth Record'
            fill_in 'birth_record_first_and_middle_names', with: 'Hine'
            fill_in 'birth_record_family_name', with: 'Whanau'
            fill_in 'birth_record_date_of_birth', with: DemoDataService::DEFAULT_CHILD_BIRTHDAY

            click_on 'Find'

            # look for exactly 1 match, we don't know the record ID though
            expect(page).to have_css(
              '.birth-record',
              count: 1
            )
          end
        end
      end
    end
  end
end
