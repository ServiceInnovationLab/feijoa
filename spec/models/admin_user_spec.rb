# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:admin_user) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
