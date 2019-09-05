# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/BirthRecordsController', type: :request do
  describe '#add' do
    context 'A User' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in user
      end

      context 'when a birth record is associated with the user' do
        let(:birth_record) { FactoryBot.create(:birth_record) }
        before do
          birth_record.add_to(user)
        end

        it 'adding it again is a no-op' do
          expect do
            post add_user_birth_record_path(birth_record)
          end.to_not(change { user.birth_records.count })
        end
      end

      context 'when a birth records is not associated with the user' do
        let(:birth_record) { FactoryBot.create(:birth_record) }

        it 'it is added' do
          expect do
            post add_user_birth_record_path(birth_record)
          end.to(change { user.birth_records.count }.by(1))
        end
      end
    end
  end
end
