# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/SharesController', type: :feature do
  describe '#new' do
    context 'A User with an associated Birth Records' do
      let(:user) { FactoryBot.create(:user) }
      let(:birth_records) { FactoryBot.create_list(:birth_record, 3) }
      let(:target_birth_record) do
        FactoryBot.create(
          :birth_record,
          first_and_middle_names: 'Timmy',
          family_name: 'Target-Person',
          date_of_birth: '1979-01-01'
        )
      end

      before do
        login_as(user, scope: :user)
        user.birth_records << birth_records
        user.birth_records << target_birth_record
      end

      context 'the user chooses to share the birth record' do
        before do
          visit user_birth_records_path
          find(".user-birth-record[data-id='#{target_birth_record.id}']").click_link('share')

          # wait for destination page to load
          page.has_css?('body.user__shares--new')
        end

        it 'renders the new share page' do
          expect(page).to have_text('New Share')
          Percy.snapshot(page, name: 'share the birth record')
        end

        it 'shows the selected birth record' do
          expect(find_field('share_birth_record_id').value).to eq(target_birth_record.id.to_s)
        end
      end
    end
  end
end
