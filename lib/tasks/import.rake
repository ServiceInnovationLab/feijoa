# frozen_string_literal: true

namespace :import do
  desc 'Import ECE from data.govt.nz'
  # usage: rake import:ece

  task ece: :environment do
    ImporterService.new.import_ece
  end
end
