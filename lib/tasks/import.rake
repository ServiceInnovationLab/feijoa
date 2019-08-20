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

  desc 'Import schools from data.govt.nz'
  # usage: rake import:schools
  task schools: :environment do
    OrganisationImporterService.new('bdfe0e4c-1554-4701-a8fe-ba1c8e0cc2ce', 'school',
                                    fields: { 'key': 'School_Id',
                                              'name': 'Org_Name',
                                              'email': 'Email',
                                              'address': 'Add1_Line1',
                                              'contact_number': 'Telephone' }).import!
  end
end
