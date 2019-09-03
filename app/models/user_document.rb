# frozen_string_literal: true

class UserDocument < ApplicationRecord
  include Discard::Model

  audited associated_with: :user, comment_required: true

  belongs_to :user
  belongs_to :document, polymorphic: true
end
