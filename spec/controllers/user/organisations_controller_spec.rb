# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::OrganisationsController, type: :controller do
  let!(:organisations) { FactoryBot.create_list :organisation, 100 }
  let!(:org) { FactoryBot.create :organisation, name: 'Mangakino Kohanga Reo' }
  let(:user) { FactoryBot.create :user }
  before { sign_in user }

  describe 'finds results for autocomplete' do
    before { get :autocomplete, format: :json, params: { query: 'manga' } }
    it { expect(response).to be_successful }
  end
end
