# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :requester, class_name: 'Organisation',
                         inverse_of: :requests, foreign_key: 'requester_id',
                         dependent: :destroy
  belongs_to :requestee, class_name: 'User',
                         inverse_of: :requests, foreign_key: 'requestee_id',
                         dependent: :destroy
  belongs_to :share, optional: true

  validates :requester, presence: true
  validates :requestee, presence: true

  delegate :email, to: :requestee, prefix: true, allow_nil: true

  validates :document_type, inclusion: { in: Document::DOCUMENT_TYPES }
  validates_associated :requestee

  scope :unresolved, -> { with_state(:initiated, :received) }

  state_machine initial: :initiated do
    event :view do
      transition initiated: :received
    end
    event :respond do
      transition initiated: :resolved
      transition received: :resolved
    end
    event :decline do
      transition initiated: :declined
      transition received: :declined
    end
    event :cancel do
      transition initiated: :cancelled
      transition received: :cancelled
    end
  end

  def respond_with_share(share)
    return false unless can_respond? && update(share: share)

    respond
  end
end
