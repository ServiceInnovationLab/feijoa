# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDocument, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:user_document) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  describe 'auditing' do
    it { should be_audited.associated_with(:user) }
  end
end
