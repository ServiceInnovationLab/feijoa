# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BirthRecord, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:birth_record) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'a valid model' do
    subject { FactoryBot.create(:birth_record) }
    let(:expected_format) { /\d{2}-\d{2}-\d{4}/ }

    it 'has a nicely formatted date of birth' do
      expect(subject.date_of_birth).to match(expected_format)
    end
  end
end
