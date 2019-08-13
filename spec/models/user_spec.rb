# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    subject { FactoryBot.create(:user) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  describe 'roles' do
    let(:user) { FactoryBot.create(:user) }
    let(:org) { FactoryBot.create(:organisation) }
    context 'for a user who is admin for one org' do
      before do
        org.add_admin(user)
      end
      it 'returns an array with one Role object when asked for combined roles' do
        expect(user.combined_roles).to eq([Role.new(role_name: 'admin', scope: org)])
      end
    end

  end
end
