# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/AuditsController', type: :request do
  context 'A User' do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end
    
    describe '#index' do
      context 'when the user has added a birth record' do
        let(:birth_record) { FactoryBot.create(:birth_record) }
        before do
          BirthRecordService.add(user: user, birth_record: birth_record)
        end

        it 'the view shows an audit for it' do
          get user_audits_path

          expect(response).to be_successful
          expect(response.body).to include(birth_record.full_name)
        end
      end
    end
  end
end
