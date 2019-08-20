# frozen_string_literal: true

DATA_GOVT_NZ = 'https://catalogue.data.govt.nz'

class OrganisationImporterService
  def initialize(data_set_id, data_source_name, fields: {})
    @data_set_id = data_set_id
    @data_source_name = data_source_name
    @fields = { name: 'Name', email: 'Email', contact_number: 'Telephone',
                address: 'Address', key: 'key' }.merge(fields)
  end

  def import!
    per_page = 500
    total_records = fetch_total_records_count
    offset = 0
    page = 0
    while offset < total_records
      ActiveRecord::Base.transaction do
        offset = page * per_page
        fetch_records(per_page, offset).each do |record|
          save_org(record)
        end
        page += 1
      end
    end
  end

  private

  def save_org(record)
    org = Organisation.find_or_initialize_by(
      data_source_key: record[@fields[:key]],
      data_source_name: @data_source_name
    )
    org.name = record[@fields[:name]]
    org.email = record[@fields[:email]]
    org.address = record[@fields[:address]]
    org.contact_number = record[@fields[:contact_number]]
    org.save!
  end

  def fetch_records(limit, offset)
    data = conn.get(data_url(
                      "SELECT * from \"#{@data_set_id}\" ORDER BY \"_id\" DESC LIMIT #{limit} OFFSET #{offset}"
                    )).body
    data.fetch('result', {}).fetch('records', {})
  end

  def fetch_total_records_count
    conn.get(data_url(
               "SELECT count(*) from \"#{@data_set_id}\""
             )).body.fetch('result').fetch('records')[0].fetch('count').to_i
  end

  def data_url(query)
    "/api/3/action/datastore_search_sql?sql=#{query}"
  end

  def conn
    Faraday.new DATA_GOVT_NZ do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
