# frozen_string_literal: true

class BirthRecord < ApplicationRecord
  has_many :birth_records_users, dependent: :destroy
  has_many :users, through: :birth_records_users
end
