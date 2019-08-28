# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::OrganisationsController, type: :controller do
  describe '#autocomplete' do
    # Give other orgs a name that won't be found when we search
    let!(:organisations) { FactoryBot.create_list :organisation, 10, name: 'sleepy coder school' }
    let!(:org) { FactoryBot.create :organisation, name: 'Mangakino Kohanga Reo' }
    let(:user) { FactoryBot.create :user }
    before { sign_in user }

    describe 'finds results for autocomplete' do
      shared_examples 'run search' do
        before do
          Organisation.reindex(async: false)
          expect(Organisation.search('*')).to include org
          get :autocomplete, format: :json, params: { query: query }
        end
        it { expect(response).to be_successful }
        it { expect(JSON.parse(response.body).first['name']).to eq(org.name) }
        it { expect(JSON.parse(response.body).first['id']).to eq(org.id) }
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
end
