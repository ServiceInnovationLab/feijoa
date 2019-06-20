# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BirthRecordService do
  # These are the keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  describe '#permitted_keys' do
    it 'is like the online birth record ordering service' do
      expect(described_class.permitted_keys).to match_array(
        %w[
          first_and_middle_names
          family_name
          date_of_birth
          place_of_birth
          parent_first_and_middle_names
          parent_family_name
          other_parent_first_and_middle_names
          other_parent_family_name
        ]
      )
    end
  end

  # These are the required keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  describe '#REQUIRED_KEYS' do
    it 'is like the online birth record ordering service' do
      expect(described_class::REQUIRED_KEYS).to match_array(
        %w[
          first_and_middle_names
          family_name
          date_of_birth
        ]
      )
    end
  end

  # These are the optional keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  describe '#OPTIONAL_KEYS' do
    it 'is like the online birth record ordering service' do
      expect(described_class::OPTIONAL_KEYS).to match_array(
        %w[
          place_of_birth
          parent_first_and_middle_names
          parent_family_name
          other_parent_first_and_middle_names
          other_parent_family_name
        ]
      )
    end
  end

  # These are the keys where we want to allow case-insensitive searching. This
  # test is to double-check you've thought about it before changing them.
  describe '#CASE_INSENSITIVE_KEYS' do
    it 'is like we decided' do
      expect(described_class::CASE_INSENSITIVE_KEYS).to match_array(
        %w[
          first_and_middle_names
          family_name
          place_of_birth
          parent_first_and_middle_names
          parent_family_name
          other_parent_first_and_middle_names
          other_parent_family_name
        ]
      )
    end
  end

  describe '#query' do
    context 'with a target record and some other records' do
      let(:target_record) do
        FactoryBot.create(
          :birth_record,
          first_and_middle_names: 'Timmy',
          family_name: 'Target-Person',
          date_of_birth: Date.parse('1979-12-25'),
          place_of_birth: 'Wellington',
          sex: 'X',
          parent_first_and_middle_names: 'Daniel',
          parent_family_name: 'Chuck',
          other_parent_first_and_middle_names: 'Tameka',
          other_parent_family_name: 'Senger'
        )
      end
      let(:birth_records) { FactoryBot.create_list(:birth_record, 10) }

      context 'a query matching the required params' do
        let(:params) { target_record.attributes.slice(*described_class::REQUIRED_KEYS) }
        it 'finds the target' do
          result = described_class.query(params)
          expect(result.length).to be(1)
          expect(result.first).to eq(target_record)
        end
      end

      context 'a query matching the permitted params' do
        let(:params) { target_record.attributes.slice(*described_class.permitted_keys) }
        it 'finds the target' do
          result = described_class.query(params)
          expect(result.length).to be(1)
          expect(result.first).to eq(target_record)
        end
      end

      context 'a query missing a required param' do
        let(:params) { target_record.attributes.slice(*described_class.permitted_keys.drop(1)) }
        it 'finds nothing' do
          result = described_class.query(params)
          expect(result).to be_empty
        end
      end

      context 'a query would match but has an unpermitted param' do
        let(:params) { target_record.attributes.slice(*described_class.permitted_keys).merge(pizza: 'yes please!') }
        it 'ignores the unpermitted param and still matches' do
          result = described_class.query(params)
          expect(result.length).to be(1)
          expect(result.first).to eq(target_record)
        end
      end

      context 'a query matching the required params, but in the wrong case' do
        # downcase the params where case insensitive search is supported
        let(:params) do
          {
            'first_and_middle_names' => target_record.first_and_middle_names.downcase,
            'family_name' => target_record.family_name.downcase,
            'date_of_birth' => target_record.date_of_birth
          }
        end

        it 'finds the target' do
          result = described_class.query(params)

          expect(result.length).to eq(1)
          expect(result.first).to eq(target_record)
        end

        context 'we override the default case insensitive fields list to force exact matches' do
          it 'doesn\'t find the target' do
            result = described_class.query(params, case_insensitive_keys: [])

            expect(result).to be_empty
          end
        end
      end
    end
  end
end
