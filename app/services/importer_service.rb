# frozen_string_literal: true

class ImporterService
  def import_ece
    page = 0
    per_page = 100
    total_records = fetch_total_records_count.to_i
    offset = 0

    while offset < total_records
      ActiveRecord::Base.transaction do
        offset = page * per_page
        records = fetch_records(per_page, offset)
        # puts data_url
        records.each do |record|
          puts record['Org_Name']
          Organisation.find_or_create_by!(name: record['Org_name'])
          # TODO: invite the first user here
        end
        page += 1
      end
    end
  end

  private

  def fetch_records(limit, offset)
    data = conn.get(data_url(
                      "SELECT * from \"#{data_set_id}\" ORDER BY \"ECE_Id\" LIMIT #{limit} OFFSET #{offset}"
                    )).body
    data.fetch('result', {}).fetch('records', {})
  end

  def fetch_total_records_count
    conn.get(data_url(
               "SELECT count(*) from \"#{data_set_id}\""
             )).body.fetch('result').fetch('records')[0].fetch('count')
  end

  def data_set_id
    '26f44973-b06d-479d-b697-8d7943c97c57'
  end

  def data_url(query)
    "/api/3/action/datastore_search_sql?sql=#{query}"
  end

  def data_govt_nz
    'https://catalogue.data.govt.nz'
  end

  def conn
    Faraday.new data_govt_nz do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
