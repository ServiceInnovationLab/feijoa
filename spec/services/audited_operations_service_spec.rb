# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditedOperationsService do

  let(:birth_record) { FactoryBot.create(:birth_record) }
  let(:organisation_user) { FactoryBot.create(:organisation_user) }

  # The details of this share are unimportant, it doesn't even have to belong to
  # the user who tries to revoke it. This service only ensures that the
  # revocation happens and that a valid user is recorded in revoked_by.
  # Authorisation is handled in the controller.
  let(:share) { FactoryBot.create(:share) }

  context 'with no user' do
    let(:user) { nil }

    describe '#add_birth_record_to_user' do
      it 'fails' do
        expect {
          described_class.add_birth_record_to_user(user: user, birth_record: birth_record)
        }.to raise_error(ArgumentError)
      end
    end

    describe '#remove_birth_record_from_user' do
      it 'fails' do
        expect {
          described_class.remove_birth_record_from_user(user: user, birth_record_id: birth_record.id)
        }.to raise_error(ArgumentError)
      end
    end

    describe '#share_birth_record_with_recipient' do
      it 'fails' do
        expect {
          described_class.share_birth_record_with_recipient(user: user, birth_record: birth_record, recipient: organisation_user)
        }.to raise_error(ArgumentError)
      end
    end

    describe '#revoke_share' do
      it 'fails' do
        expect {
          described_class.revoke_share(share: share, revoked_by: user)
        }.to raise_error(ArgumentError)
      end
    end
  end

  context 'with a User' do
    let(:user) { FactoryBot.create(:user) }

    describe '#add_birth_record_to_user' do
      it 'audits that the record was added' do
        expect {
          described_class.add_birth_record_to_user(user: user, birth_record: birth_record)
        }.to change { user.audits.count }.by(1)
      end

      describe '#remove_birth_record_from_user' do
        before do
          described_class.add_birth_record_to_user(user: user, birth_record: birth_record)
        end

        it 'audits that the record was removed' do
          expect {
            described_class.remove_birth_record_from_user(user: user, birth_record_id: birth_record.id)
          }.to change { user.audits.count }.by(1)
        end
      end

    end

    describe '#share_birth_record_with_recipient' do
      it 'audits that the record was shared' do
        expect {
          described_class.share_birth_record_with_recipient(
            user: user,
            birth_record: birth_record,
            recipient: organisation_user
          )
        }.to change { user.audits.count }.by(1)
      end
    end

    describe '#revoke_share' do
      it 'audits that the record was revoked' do
        expect {
          described_class.revoke_share(user: user, share: share)
        }.to change { user.audits.count }.by(1)
      end
    end
  end
end
