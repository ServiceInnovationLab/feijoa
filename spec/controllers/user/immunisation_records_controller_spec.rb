# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ImmunisationRecordsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  before do
    sign_in user
  end

  describe 'new' do
    it 'shows a form' do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe 'create' do
    it 'creates an immunisation record with valid params' do
      expect do
        post :create, params: {
          immunisation_record: FactoryBot.build(:immunisation_record).attributes
        }
      end.to change(ImmunisationRecord, :count).by(1)
    end
    it 'assigns the immunisation record to the user' do
      expect do
        post :create, params: {
          immunisation_record: FactoryBot.build(:immunisation_record).attributes
        }
      end.to change(user.immunisation_records, :count).by(1)
    end
  end
  describe 'update' do
    let(:new_data) { { 'a' => 'b' } }
    let!(:immunisation_record) { FactoryBot.create(:immunisation_record) }
    let(:fetcher_double) { double(ImmunisationDataFetcher, fetch_data: new_data) }
    before do
      allow(ImmunisationDataFetcher).to receive(:new).and_return(fetcher_double)
    end
    it 'updates the data' do
      post :update, params: { id: immunisation_record.id }
      expect(immunisation_record.reload.data).to eq(new_data)
    end
  end
end
