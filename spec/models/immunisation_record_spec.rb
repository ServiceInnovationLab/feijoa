# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImmunisationRecord, type: :model do
  let(:document) { FactoryBot.create(:immunisation_record) }
  it_behaves_like 'a document'

  describe 'validations' do
    let(:valid_nhi) { 'CGC2720' }
    let(:invalid_nhi) { 'DAB8233' }
    let(:lowercase_nhi) { 'zzz0024' }

    let(:lowercase_imm) { FactoryBot.create(:immunisation_record, nhi: lowercase_nhi) }
    let(:valid_nhi_imm) { FactoryBot.build(:immunisation_record, nhi: valid_nhi) }
    let(:invalid_nhi_imm) { FactoryBot.build(:immunisation_record, nhi: invalid_nhi) }
    let(:no_name_imm) { FactoryBot.build(:immunisation_record, full_name: nil) }
    let(:no_dob_imm) { FactoryBot.build(:immunisation_record, date_of_birth: nil) }

    it 'requires NHI number to be valid' do
      expect(valid_nhi_imm).to be_valid
      expect(invalid_nhi_imm).not_to be_valid
    end

    it 'transforms NHI number to upcase' do
      expect(lowercase_imm.nhi).to eq(lowercase_nhi.upcase)
    end

    it 'requires name' do
      expect(no_name_imm).not_to be_valid
    end
    it 'requires date of birth' do
      expect(no_dob_imm).not_to be_valid
    end
  end
end
