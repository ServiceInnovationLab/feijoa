# frozen_string_literal: true

class Share < ApplicationRecord
  include Discard::Model
  self.discard_column = :revoked_at

  audited associated_with: :user, comment_required: true

  belongs_to :document, polymorphic: true
  belongs_to :user

  belongs_to :recipient, polymorphic: true
  belongs_to :revoked_by, polymorphic: true, optional: true

  validates :user, presence: true
  validates :recipient, presence: true
  validates :document, presence: true

  validate :not_currently_shared, on: :create

  scope :unrevoked, -> { where(revoked_by: nil) }
  scope :revoked, -> { where.not(revoked_by: nil) }

  def revoke(revoked_by:)
    AuditedOperationsService.revoke_share(share: self, user: revoked_by)
  end

  def revoked?
    revoked_by.present?
  end

  def unrevoked?
    !revoked?
  end

  private

  # True if the user doesn't have any active (not soft deleted) shares of this
  # birth record with this recipient
  def not_currently_shared
    return false unless Share.where(recipient: recipient, user: user, document: document).kept.any?

    errors.add(:recipient, 'is currently shared with this entity')
  end
end
