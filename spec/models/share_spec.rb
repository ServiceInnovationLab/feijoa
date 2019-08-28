# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Share, type: :model do
  let(:user) { FactoryBot.create(:user) }
  subject { FactoryBot.create(:share) }

  describe 'Factory' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  describe 'auditing' do
    it { should be_audited.associated_with(:user) }
  end

  describe '#revoke' do
    it 'sets revoked_by and revoked_at' do
      AuditedOperationsService.revoke_share(share: subject, user: user)

      subject.reload

      expect(subject.revoked_by).to eq(user)
      expect(subject.revoked_at).not_to be_nil
      expect(Share.discarded).to include(subject)
      expect(Share.kept).not_to include(subject)
    end
  end
end
