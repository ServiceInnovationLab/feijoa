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

  context 'a User' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation_user) { FactoryBot.create(:organisation_user) }
    let(:share) { FactoryBot.create(:share, user: user, recipient: organisation_user) }

    before do
      sign_in user
      share
    end

    describe 'GET #index' do
      it 'is redirected away' do
        get :index
        expect(response).to redirect_to(new_organisation_user_session_path)
      end
    end

    describe 'GET #show' do
      it 'is redirected away' do
        get :show, params: { id: share.to_param }
        expect(response).to redirect_to(new_organisation_user_session_path)
      end
    end
  end

  context 'an Admin user' do
    let(:admin_user) { FactoryBot.create(:admin_user) }
    let(:user) { FactoryBot.create(:user) }
    let(:organisation_user) { FactoryBot.create(:organisation_user) }
    let(:share) { FactoryBot.create(:share, user: user, recipient: organisation_user) }

    before do
      sign_in admin_user
      share
    end

    describe 'GET #index' do
      it 'is redirected away' do
        get :index
        expect(response).to redirect_to(new_organisation_user_session_path)
      end
    end

    describe 'GET #show' do
      it 'is redirected away' do
        get :show, params: { id: share.to_param }
        expect(response).to redirect_to(new_organisation_user_session_path)
      end
    end
  end

  context 'an unauthenticated guest user' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation_user) { FactoryBot.create(:organisation_user) }
    let(:share) { FactoryBot.create(:share, user: user, recipient: organisation_user) }

    before do
      share
    end

    describe 'GET #index' do
      it 'is redirected away' do
        get :index
        expect(response).to redirect_to(new_organisation_user_session_path)
      end
    end

    describe 'GET #show' do
      it 'is redirected away' do
        get :show, params: { id: share.to_param }
        expect(response).to redirect_to(new_organisation_user_session_path)
      end
    end
  end
end
