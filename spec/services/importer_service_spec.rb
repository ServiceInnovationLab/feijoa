# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImporterService do
  describe 'fetch total count' do
    let(:data_set_id) { '123' }
    let(:count_response_body) { { 'result' => { 'records' => [{ 'count' => '99' }] } } }
    let(:query_response_body) { { 'result' => { 'records' => [record] } } }

    let(:record) { { 'Name' => 'Super Kewl Kindy' } }
    before(:each) do
      response = double('response')
      allow(response).to receive(:body).and_return(count_response_body)
      allow(Faraday).to receive(:new).and_return(double(Faraday, get: response))
    end
    subject { ImporterService.new(data_set_id, fields: { name: 'Name' }) }
    it { expect(subject.send(:data_url, 'SELECT * FROM blah')).to eq('/api/3/action/datastore_search_sql?sql=SELECT * FROM blah') }
    it { expect(subject.send(:fetch_total_records_count)).to eq 99 }
    it { expect(subject.send(:data_govt_nz)).to eq 'https://catalogue.data.govt.nz' }
    it { expect { subject.send(:save_org, record) }.to change(Organisation, :count).by(1) }

    describe 'retrieving and saving records' do
      before(:each) do
        response = double('response')
        allow(response).to receive(:body).and_return(count_response_body, query_response_body)
        allow(Faraday).to receive(:new).and_return(double(Faraday, get: response))
      end
      it { expect { subject.import! }.to change(Organisation, :count).by(1) }
      it "saves with correct name" do
        subject.import!
        expect(Organisation.last.name).to eq 'Super Kewl Kindy'
      end
    end
  end
end
