# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Share, type: :model do
  describe 'an active share' do
    subject { FactoryBot.create(:share) }

    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is not revoked' do
      expect(subject).not_to be_revoked
    end

    it 'is in the #active scope' do
      expect(Share.active).to include(subject)
    end


    it 'can be revoked by a user' do
      account = FactoryBot.create(:user)
      subject.revoke(account)
      subject.reload

      expect(subject).to be_revoked
      expect(subject.revoked_at).not_to be_nil
      expect(subject.revoker).to eq(account)
    end

    it 'can be revoked by an admin' do
      account = FactoryBot.create(:admin_user)
      subject.revoke(account)
      subject.reload

      expect(subject).to be_revoked
      expect(subject.revoked_at).not_to be_nil
      expect(subject.revoker).to eq(account)
    end

    it 'can be revoked by an organisation' do
      account = FactoryBot.create(:organisation_user)
      subject.revoke(account)
      subject.reload

      expect(subject).to be_revoked
      expect(subject.revoked_at).not_to be_nil
      expect(subject.revoker).to eq(account)
    end
  end

  describe 'a revoked share' do
    subject { FactoryBot.create(:share, :revoked) }

    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is revoked' do
      expect(subject).to be_revoked
    end

    it 'is in the #revoked scope' do
      expect(Share.revoked).to include(subject)
    end
  end
end
