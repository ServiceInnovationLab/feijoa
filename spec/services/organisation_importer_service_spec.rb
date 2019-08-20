# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationImporterService do
  describe 'fetch total count' do
    let(:data_set_id) { '123' }
    let(:count_response_body) { { 'result' => { 'records' => [{ 'count' => '99' }] } } }
    let(:query_response_body) { { 'result' => { 'records' => [record] } } }

    let(:record) do
      { 'Name' => 'Super Kewl Kindy', 'Telephone' => '321',
        'Address' => 'main road', 'Email' => 'me@example.com', 'key' => '99' }
    end
    let(:response) { double('response') }
    before(:each) do
      allow(response).to receive(:body).and_return(count_response_body)
      allow(Faraday).to receive(:new).and_return(double(Faraday, get: response))
    end
    subject { OrganisationImporterService.new(data_set_id, 'jelly', fields: { name: 'Name' }) }
    it { expect(subject.send(:data_url, 'HELLO')).to eq('/api/3/action/datastore_search_sql?sql=HELLO') }
    it { expect(subject.send(:fetch_total_records_count)).to eq 99 }
    it { expect { subject.send(:save_org, record) }.to change(Organisation, :count).by(1) }

    describe 'retrieving and saving records' do
      before { allow(response).to receive(:body).and_return(count_response_body, query_response_body) }
      it 'saves with correct name' do
        subject.import!
        expect(Organisation.last.name).to eq 'Super Kewl Kindy'
        expect(Organisation.last.email).to eq 'me@example.com'
        expect(Organisation.last.address).to eq 'main road'
        expect(Organisation.last.contact_number).to eq '321'
        expect(Organisation.last.data_source_name).to eq 'jelly'
        expect(Organisation.last.data_source_key).to eq '99'
      end
      it 'does not make duplicate records if run again' do
        allow(response).to receive(:body).and_return(count_response_body, query_response_body)
        expect { subject.import! }.to change(Organisation, :count).by(1)

        allow(response).to receive(:body).and_return(count_response_body, query_response_body)
        expect { subject.import! }.not_to change(Organisation, :count)
      end
    end
  end
end
