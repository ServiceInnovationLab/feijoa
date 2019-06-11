# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/BirthRecordController#show', type: :request do
  context 'A User' do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end

    context 'when a birth record is associated with the user' do
      let(:birth_record) { FactoryBot.create(:birth_record) }
      before do
        user.birth_records << birth_record
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
