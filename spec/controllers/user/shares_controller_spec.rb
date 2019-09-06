# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::SharesController, type: :controller do
  context 'A user is signed in and has an existing share' do
    let(:user) { FactoryBot.create(:user) }
    let!(:share) { FactoryBot.create(:share, user: user) }
    let(:invalid_attributes) { { user_id: nil } }
    let(:birth_record) { FactoryBot.create(:birth_record) }
    let!(:birth_records_user) do
      FactoryBot.create(:user_document, document: birth_record, user: user)
    end
    let(:valid_attributes) do
      FactoryBot
        .build(
          :share,
          user: user,
          recipient: FactoryBot.create(:organisation),
          document: birth_record
        )
        .attributes
    end

    context 'anonymous' do
      describe '#index' do
        before { get :index }
        it { expect(response).to redirect_to new_user_session_path }
      end
      describe '#show' do
        before { get :show, params: { id: share.to_param } }
        it { expect(response).to redirect_to new_user_session_path }
      end
      describe '#new' do
        before { get :new }
        it { expect(response).to redirect_to new_user_session_path }
      end
      describe 'POST #create' do
        let(:params) { { share: valid_attributes } }
        it 'does not create a share' do
          expect do
            post :create, params: params
          end.not_to change(Share, :count)
        end
        before { post :create, params: params }
        it { expect(response).to redirect_to new_user_session_path }
      end
    end

    context 'signed in' do
      include_context 'signed in'

      describe 'GET #index' do
        before { get :index }
        it 'returns a success response' do
          expect(response).to be_successful
        end
      end

      describe 'GET #show' do
        before { get :show, params: { id: share.to_param } }
        it 'returns a success response' do
          expect(response).to be_successful
        end
      end

      describe 'POST #create' do
        context 'with valid params' do
          it 'creates a new Share' do
            expect do
              post :create, params: { share: valid_attributes }
            end.to change(Share, :count).by(1)
          end

          it 'redirects to the created share' do
            post :create, params: { share: valid_attributes }
            expect(response).to redirect_to(
              user_document_path(Share.last.document.document_type, Share.last.document.id)
            )
          end
        end

        context 'with invalid params' do
          it 'raises an error' do
            expect do
              post :create, params: { share: invalid_attributes }
            end.to raise_error(ActionController::ParameterMissing)
          end
        end
      end
    end
  end
end
