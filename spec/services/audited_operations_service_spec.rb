# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditedOperationsService do
  let(:birth_record) { FactoryBot.create(:birth_record) }
  let(:organisation) { FactoryBot.create(:organisation) }

  # The details of this share are unimportant, it doesn't even have to belong to
  # the user who tries to revoke it. This service only ensures that the
  # revocation happens and that a valid user is recorded in revoked_by.
  # Authorisation is handled in the controller.
  let(:share) { FactoryBot.create(:share) }

  context 'with no user' do
    let(:user) { nil }

    describe '#add_birth_record_to_user' do
      it 'fails' do
        expect do
          described_class.add_birth_record_to_user(user: user, birth_record: birth_record)
        end.to raise_error(ArgumentError)
      end
    end

    describe '#remove_birth_record_from_user' do
      it 'fails' do
        expect do
          described_class.remove_birth_record_from_user(user: user, birth_record_id: birth_record.id)
        end.to raise_error(ArgumentError)
      end
    end

    describe '#share_birth_record_with_recipient' do
      it 'fails' do
        expect do
          described_class.share_birth_record_with_recipient(
            user: user,
            birth_record: birth_record,
            recipient: organisation
          )
        end.to raise_error(ArgumentError)
      end
    end

    describe '#revoke_share' do
      it 'fails' do
        expect do
          described_class.revoke_share(share: share, revoked_by: user)
        end.to raise_error(ArgumentError)
      end
    end
  end

  context 'with a User' do
    let(:user) { FactoryBot.create(:user) }

    describe '#add_birth_record_to_user' do
      it 'audits that the record was added' do
        expect do
          described_class.add_birth_record_to_user(user: user, birth_record: birth_record)
        end.to change { user.audits.count }.by(1)
      end

      describe '#remove_birth_record_from_user' do
        before do
          described_class.add_birth_record_to_user(user: user, birth_record: birth_record)
        end

        it 'audits that the record was removed' do
          expect do
            described_class.remove_birth_record_from_user(user: user, birth_record_id: birth_record.id)
          end.to change { user.audits.count }.by(1)
        end
      end
    end

    describe '#share_birth_record_with_recipient' do
      it 'audits that the record was shared' do
        expect do
          described_class.share_birth_record_with_recipient(
            user: user,
            birth_record: birth_record,
            recipient: organisation
          )
        end.to change { user.audits.count }.by(1)
      end
    end

    describe '#revoke_share' do
      it 'audits that the record was revoked' do
        expect do
          described_class.revoke_share(user: user, share: share)
        end.to change { user.audits.count }.by(1)
      end
    end
  end

  describe '#access_shared_document' do
    let(:user) { FactoryBot.create(:user) }
    let(:document) { FactoryBot.create(:birth_record) }
    let(:share) { FactoryBot.create(:share, document: document) }
    it 'audits that the record was accessed' do
      expect do
        described_class.access_shared_document(user: user, share: share)
      end.to change { user.audits.count }.by(1)
    end
    it 'uses the audit comment from the share document class' do
      described_class.access_shared_document(user: user, share: share)
      expect(share.audits.last.comment).to eq(BirthRecord.view_audit_comment)
    end
    context 'when the shared document is an immunisation record' do
      let(:document) { FactoryBot.create(:immunisation_record) }
      it 'uses the immunisation record audit comment' do
        described_class.access_shared_document(user: user, share: share)
        expect(share.audits.last.comment).to eq(ImmunisationRecord.view_audit_comment)
      end
    end
  end
end
