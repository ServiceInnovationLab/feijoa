# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Share, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:share) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  describe 'auditing' do
    it { should be_audited.associated_with(:birth_record) }
  end
end
