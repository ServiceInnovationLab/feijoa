# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::OrganisationsController, type: :controller do
  describe '#autocomplete' do
    # Give other orgs a name that won't be found when we search
    let!(:organisations) { FactoryBot.create_list :organisation, 10, name: 'sleepy coder school' }
    let!(:organisation) { FactoryBot.create :organisation, name: 'Mangakino Kohanga Reo' }
    let(:user) { FactoryBot.create :user }

    shared_examples 'can access autocomplete' do
      describe 'finds results for autocomplete' do
        shared_examples 'run search' do
          before do
            Organisation.reindex(async: false)
            expect(Organisation.search('*')).to include organisation
            get :autocomplete, format: :json, params: { query: query }
          end
          it { expect(response).to be_successful }
          it { expect(JSON.parse(response.body).first['name']).to eq(organisation.name) }
          it { expect(JSON.parse(response.body).first['id']).to eq(organisation.id) }
        end

        describe 'whole word' do
          let(:query) { 'Mangakino' }
          include_examples 'run search'
        end
        describe 'lower case' do
          let(:query) { 'mangakino' }
          include_examples 'run search'
        end
        describe 'partial word' do
          let(:query) { 'manga' }
          include_examples 'run search'
        end
      end
    end

    context 'anonymous' do
      before { get :autocomplete, format: :json, params: { query: 'a' } }
      it 'not authorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'signed in as public user' do
      before { sign_in user }
      include_examples 'can access autocomplete'
    end

    context 'signed in as org staff user' do
      before do
        user.add_role(organisation, 'staff')
        sign_in user
      end
      include_examples 'can access autocomplete'
    end
  end
end
