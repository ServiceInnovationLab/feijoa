# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::SharesController, type: :controller do
  context 'An organisation member is signed in and has an existing share' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation) { FactoryBot.create(:organisation) }
    let(:share) { FactoryBot.create(:share, user: FactoryBot.create(:user), recipient: organisation) }
    let(:invalid_attributes) { { user_id: nil } }

    before do
      organisation.add_staff(user)
      user.reload
      sign_in user
      share
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: share.to_param }
        expect(response).to be_successful
      end
    end
  end
end
