# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::SharesController, type: :controller do
  context 'A user is signed in and has an existing share' do
    let(:user) { FactoryBot.create(:user) }
    let(:share) { FactoryBot.create(:share, user: user) }
    let(:invalid_attributes) { { user_id: nil } }

    before do
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

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        let(:valid_attributes) do
          FactoryBot.build(
            :share,
            user: user,
            recipient: FactoryBot.create(:organisation_user),
            birth_record: FactoryBot.create(:birth_record)
          ).attributes
        end

        it 'creates a new Share' do
          expect do
            post :create, params: { share: valid_attributes }
          end.to change(Share, :count).by(1)
        end

        it 'redirects to the created share' do
          post :create, params: { share: valid_attributes }
          expect(response).to redirect_to(user_birth_record_path(Share.last.birth_record))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { share: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end
  end
end
