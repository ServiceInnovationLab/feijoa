# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organisation, type: :model do
  describe 'when a record already exist with same data source key and name' do
    let(:ds_name) { 'chocolate' }
    let(:ds_id) { '123' }
    before { FactoryBot.create :organisation, data_source_key: ds_id, data_source_name: ds_name }

    it "doesn't allow duplicate records for same data_source record" do
      expect do
        FactoryBot.create :organisation, data_source_key: ds_id, data_source_name: ds_name
      end.to raise_error ActiveRecord::RecordInvalid
    end
    it do
      expect(FactoryBot.build(:organisation, data_source_key: ds_id, data_source_name: ds_name).valid?).to eq false
    end
  end
  describe 'allows nil data_source on organisations' do
    before { FactoryBot.create :organisation, data_source_key: nil, data_source_name: nil }
    it do
      expect do
        FactoryBot.create :organisation, data_source_key: nil, data_source_name: nil
      end.not_to raise_error
    end
  end
end
