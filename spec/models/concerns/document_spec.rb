# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :concern do
  describe 'associations' do
    let(:immunisation_record) { FactoryBot.create(:immunisation_record, id: 1_234_567) }
    let(:birth_record) { FactoryBot.create(:birth_record, id: 1_234_567) }
    let!(:share_of_birth_record) { FactoryBot.create(:share, document: birth_record) }
    let!(:share_of_immunisation_record) { FactoryBot.create(:share, document: immunisation_record) }
    let!(:birth_record_user_document) { FactoryBot.create(:user_document, document: birth_record) }
    let!(:immunisation_record_user_document) { FactoryBot.create(:user_document, document: immunisation_record) }

    it 'is associated with shares' do
      expect(immunisation_record.shares).to include(share_of_immunisation_record)
      expect(birth_record.shares).to include(share_of_birth_record)
    end

    it 'does not include shares of other types of documents with the same IDs' do
      expect(immunisation_record.shares).not_to include(share_of_birth_record)
      expect(birth_record.shares).not_to include(share_of_immunisation_record)
    end

    it 'is associated with user documents' do
      expect(immunisation_record.user_documents).to include(immunisation_record_user_document)
      expect(birth_record.user_documents).to include(birth_record_user_document)
    end

    it 'does not include user documents of other types of documents with the same IDs' do
      expect(immunisation_record.user_documents).not_to include(birth_record_user_document)
      expect(birth_record.user_documents).not_to include(immunisation_record_user_document)
    end

    it 'is associated with users' do
      expect(immunisation_record.users).to include(immunisation_record_user_document.user)
      expect(birth_record.users).to include(birth_record_user_document.user)
    end

    context 'shared_with?' do
      let(:organisation) { FactoryBot.create(:organisation) }
      let!(:share_of_immunisation_record) do
        FactoryBot.create(:share, document: immunisation_record, recipient: organisation)
      end
      let(:organisation_user) do
        user = FactoryBot.create(:user)
        organisation.add_staff(user)
        user
      end
      let(:staff_of_other_organisation) do
        user = FactoryBot.create(:user)
        FactoryBot.create(:organisation).add_staff(user)
        user
      end
      let(:user_with_document) do
        u = FactoryBot.create(:user)
        immunisation_record.add_to(u)
        u
      end

      it 'is shared with someone who is a member of an organisation the doc has been shared with' do
        expect(immunisation_record.shared_with?(organisation_user)).to eq true
      end

      it 'is not shared with someone just because they have it on their record' do
        expect(immunisation_record.shared_with?(user_with_document)).to eq false
      end

      it 'is not shared with someone who is staff of an organisation the doc has not been shared with' do
        expect(immunisation_record.shared_with?(staff_of_other_organisation)).to eq false
      end
    end
  end
end
