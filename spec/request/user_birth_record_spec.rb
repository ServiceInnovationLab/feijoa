# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/BirthRecordsController', type: :request do
  describe '#index' do
    context 'A User' do
      let(:user) { FactoryBot.create(:user) }

      before { sign_in user }

      context 'when a birth record is associated with the user' do
        let(:birth_record) { FactoryBot.create(:birth_record) }
        before do
          birth_record.add_to(user)
        end

        it 'the view lists it' do
          get user_birth_records_path

          expect(response).to be_successful
          expect(response.body).to include(birth_record.first_and_middle_names)
        end
      end

      context 'when a birth records is not associated with the user' do
        let(:birth_record) { FactoryBot.create(:birth_record) }

        it 'the view does not list it' do
          get user_birth_records_path

          expect(response).to be_successful
          expect(response.body).to_not include(birth_record.first_and_middle_names)
        end
      end
    end
  end
  describe '#show' do
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

        it 'they can view it' do
          get user_birth_record_path(birth_record)

          expect(response).to be_successful
          expect(response.body).to include(birth_record.first_and_middle_names)
        end
      end

      context 'when a birth records is not associated with the user' do
        let(:birth_record) { FactoryBot.create(:birth_record) }

        it 'the record is not found' do
          expect do
            get user_birth_record_path(birth_record)
          end.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
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
  describe '#remove' do
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

        it 'is removed' do
          expect do
            post remove_user_birth_record_path(birth_record)
          end.to(change { user.birth_records.count }.by(-1))
        end
      end

      context 'when a birth records is not associated with the user' do
        let(:birth_record) { FactoryBot.create(:birth_record) }

        it 'is a no-op' do
          expect do
            post remove_user_birth_record_path(birth_record)
          end.to_not(change { user.birth_records.count })
        end
      end
    end
  end
end
