# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BirthRecord, type: :model do
  let(:document) { FactoryBot.create(:birth_record) }
  it_behaves_like 'a document'

  describe 'Factory' do
    subject { FactoryBot.create(:birth_record) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'a valid model' do
    subject do
      FactoryBot.create(
        :birth_record,
        first_and_middle_names: 'Ruby Ru',
        family_name: 'Wallace',
        date_of_birth: '2018-01-12'
      )
    end
    let(:expected_format) { /\d{2}-\d{2}-\d{4}/ }

    it 'has a nicely formatted date of birth' do
      expect(subject.date_of_birth).to match(expected_format)
    end
  end

  context 'auditing' do
    it { should have_associated_audits }
  end

  describe 'has many shares' do
    let(:birth_record) { FactoryBot.create :birth_record }
    let(:user) { FactoryBot.create :user }
    let(:recipient) { FactoryBot.create :organisation }
    it "doesn't make duplicate shares" do
      FactoryBot.create :share, document: birth_record,
                                user: user, recipient: recipient
      expect(birth_record.shares.size).to eq 1

      expect do
        FactoryBot.create :share, document: birth_record,
                                  user: user, recipient: recipient
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe 'adding to a user' do
    let(:birth_record) { FactoryBot.create(:birth_record) }
    let(:user) { FactoryBot.create :user }
    before do
      birth_record.add_to(user)
    end
    it 'creates a user_document linking the birth record and user' do
      expect(birth_record.users).to eq([user])
      expect(user.birth_records).to eq([birth_record])
    end
  end
end
