# frozen_string_literal: true

namespace :import do
  desc 'Import ECE from data.govt.nz'
  # usage: rake import:ece
  task ece: :environment do
    OrganisationImporterService.new(dataset_id: '26f44973-b06d-479d-b697-8d7943c97c57',
                                    data_source_name: 'ece',
                                    fields: {
                                      'key': 'ECE_Id',
                                      'name': 'Org_Name',
                                      'address': 'Add1_Line1'
                                    }).import!
  end

  desc 'Import schools from data.govt.nz'
  # usage: rake import:schools
  task schools: :environment do
    OrganisationImporterService.new(dataset_id: 'bdfe0e4c-1554-4701-a8fe-ba1c8e0cc2ce',
                                    data_source_name: 'schools',
                                    fields: {
                                      'key': 'School_Id',
                                      'name': 'Org_Name',
                                      'address': 'Add1_Line1'
                                    }).import!
  end

  desc 'Import kura kaupapa maori from data.govt.nz'
  # usage: rake import:tkkm
  task tkkm: :environment do
    OrganisationImporterService.new(dataset_id: 'a476fde6-b0bb-43d8-8e60-c9d8d594b385',
                                    data_source_name: 'tkkm',
                                    fields: {
                                      'key': 'School Number',
                                      'name': 'School Name',
                                      'email': 'Email^',
                                      'address': 'Postal Address 1'
                                    }).import!
  end
end
