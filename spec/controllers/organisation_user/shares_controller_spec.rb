# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationUser::SharesController, type: :controller do
  context 'An organisation user is signed in and has an existing share' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation_user) { FactoryBot.create(:organisation_user) }
    let(:share) { FactoryBot.create(:share, user: user, recipient: organisation_user) }
    let(:invalid_attributes) { { user_id: nil } }

    before do
      sign_in organisation_user
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
