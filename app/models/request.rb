# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :requester, class_name: 'Organisation',
                         inverse_of: :request, foreign_key: 'requester_id',
                         dependent: :destroy
  belongs_to :requestee, class_name: 'User',
                         inverse_of: :request, foreign_key: 'requestee_id',
                         dependent: :destroy

  validates :requester, presence: true
  validates :requestee, presence: true

  scope :unresolved, -> { with_state(:initiated, :received) }

  state_machine initial: :initiated do
    event :view do
      transition initiated: :received
    end
    event :respond do
      transition received: :responded
    end
    event :decline do
      transition received: :declined
      transition responded: :declined
    end
    event :cancel do
      transition initiated: :cancelled
      transition received: :cancelled
      transition responded: :cancelled
    end
  end
end
