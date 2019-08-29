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

  describe 'revocation' do
    context 'when a user has previously revoked a share for the same document' do
      let(:share) { FactoryBot.create(:share) }
      before do
        AuditedOperationsService.revoke_share(user: share.user, share: share)
      end
      it 'allows the creation of a new share' do
        new_share = AuditedOperationsService.share_birth_record_with_recipient(
          birth_record: share.birth_record,
          user: share.user,
          recipient: share.recipient
        )
        expect(new_share).to be_valid
      end
    end
  end
end
