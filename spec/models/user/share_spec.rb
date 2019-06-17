# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Share, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:user_share) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
