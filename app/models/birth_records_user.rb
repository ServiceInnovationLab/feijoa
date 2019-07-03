# frozen_string_literal: true

class BirthRecordsUser < ApplicationRecord
  include Discard::Model

  audited associated_with: :user, comment_required: true

  belongs_to :user
  belongs_to :birth_record
end
