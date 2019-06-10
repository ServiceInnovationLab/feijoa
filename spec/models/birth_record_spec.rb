# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BirthRecord, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:birth_record) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
