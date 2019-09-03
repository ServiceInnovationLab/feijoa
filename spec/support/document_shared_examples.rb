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

RSpec.shared_context 'document types' do
  def create_lists_of_documents(length: 3)
    docs = []
    Document::DOCUMENT_TYPES.each do |document_type|
      docs << FactoryBot.create_list(document_type.underscore.to_sym, length)
    end
    docs
  end

  Document::DOCUMENT_TYPES.each do |document_type|
    let(document_type.underscore.to_sym) { FactoryBot.create(document_type.underscore.to_sym) }
  end

  let(:one_of_each_document_type) do
    docs = []
    Document::DOCUMENT_TYPES.each do |document_type|
      docs << FactoryBot.create(document_type.underscore.to_sym)
    end
    docs
  end

end
