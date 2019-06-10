# frozen_string_literal: true

class BirthRecord < ApplicationRecord
  has_and_belongs_to_many :users
end
