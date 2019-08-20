# frozen_string_literal: true

namespace :import do
  desc 'Import ECE from data.govt.nz'
  # usage: rake import:ece

  task ece: :environment do
    OrganisationImporterService.new('26f44973-b06d-479d-b697-8d7943c97c57', 'ece',
                        fields: { 'key': 'ECE_Id',
                                  'name': 'Org_Name',
                                  'email': 'Email',
                                  'address': 'Add1_Line1',
                                  'contact_number': 'Telephone' }).import!
  end
end
