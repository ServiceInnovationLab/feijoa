# frozen_string_literal: true

class ImmunisationDataFetcher
  def initialize(immunisation_record)
    @immunisation_record = immunisation_record
  end

  def fetch_data
    data = connection.get(
      immunisation_record_url(
        @immunisation_record.id,
        @immunisation_record.date_of_birth.iso8601
      )
    ).body
    data.fetch('data')
  end

  private

  def connection
    @connection ||= Faraday.new immunisation_record_provider do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end

  def immunisation_record_url(id, date_of_birth)
    "/immunisation_records/#{id}?date_of_birth=#{date_of_birth}"
  end

  def immunisation_record_provider
    ENV['IMMS_DATA_SERVER']
  end
end
