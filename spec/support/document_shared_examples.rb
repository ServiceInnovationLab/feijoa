# frozen_string_literal: true

RSpec.shared_examples 'a document' do
  describe 'adding to a user' do
    let(:user) { FactoryBot.create :user }
    before do
      document.add_to(user)
    end
    it 'creates a user_document linking the immunisation record and user' do
      expect(document.users).to eq([user])
      expect(user.documents).to eq([document])
    end
  end

  describe 'removing from a user' do
    let(:user) { FactoryBot.create(:user) }
    let!(:user_document) { FactoryBot.create(:user_document, document: document, user: user) }
    before do
      document.remove_from(user)
    end
    it 'discards the user document' do
      expect(user_document.reload.discarded?).to eq(true)
      expect(user.documents).not_to include(document)
    end
  end

  describe 'sharing with an organisation' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation) { FactoryBot.create(:organisation) }
    let!(:user_document) { FactoryBot.create(:user_document, document: document, user: user) }
    before do
      document.share_with(recipient: organisation, user: user)
    end
    it 'creates a share' do
      expect(user.shares).not_to be_empty
    end
    it 'creates an audit' do
      expect(user.shares.first.audits.first.comment).to eq(described_class.share_audit_comment)
    end
  end
end
