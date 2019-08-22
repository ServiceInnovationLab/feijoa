# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request, type: :model do
  subject { FactoryBot.create(:request) }

  describe 'Factory' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  describe 'Request#unresolved' do
    it 'includes initiated and received requests but not cancelled, declined or resolved ones' do
      FactoryBot.create(:request, state: :cancelled)
      FactoryBot.create(:request, state: :declined)
      FactoryBot.create(:request, state: :resolved)
      initiated_request = FactoryBot.create(:request, state: :initiated)
      received_request = FactoryBot.create(:request, state: :received)

      expect(Request.unresolved).to contain_exactly(initiated_request, received_request)
    end
  end
end
