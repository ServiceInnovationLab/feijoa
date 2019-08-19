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
    it 'includes initiated and received requests but not cancelled, declined or responded ones'
  end
end
