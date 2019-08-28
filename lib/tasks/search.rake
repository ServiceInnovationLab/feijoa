# frozen_string_literal: true

namespace :search do
  desc 'Update elastic search index'
  # usage: rake import:ece
  task index: :environment do
    Organisation.reindex
  end
end
