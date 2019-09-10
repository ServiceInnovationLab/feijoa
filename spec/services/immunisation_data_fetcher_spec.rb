# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImmunisationDataFetcher do
  describe 'fetching data for an immmunisation record' do
    let(:json_response) { JSON.parse(File.read('spec/support/immunisation_data_response.json')) }
    let(:response) { double('response') }
    let(:faraday_double) { double(Faraday, get: response) }
    before(:each) do
      allow(response).to receive(:body).and_return(json_response)
      allow(Faraday).to receive(:new).and_return(faraday_double)
    end

    let(:immunisation_record) { FactoryBot.create(:immunisation_record, data: {}) }
    subject { ImmunisationDataFetcher.new(immunisation_record) }

    it 'returns the data from the response' do
      expect(subject.fetch_data).to eq(json_response['data'])
    end

    it 'sends the full URL of the document' do
      url = "http://localhost:3000/user/documents/ImmunisationRecord/#{immunisation_record.id}"
      expect(faraday_double).to receive(:get).with(
        "/immunisation_records?feijoa_id=#{url}&date_of_birth=#{immunisation_record.date_of_birth.iso8601}"
      )
      subject.fetch_data
    end
  end
end
