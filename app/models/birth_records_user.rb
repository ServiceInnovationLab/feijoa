# frozen_string_literal: true

class BirthRecordsUser < ApplicationRecord
  belongs_to :user
  belongs_to :birth_record
end
