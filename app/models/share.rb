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

  delegate :document_type, to: :document
  delegate :view_audit_comment, to: :document
  delegate :share_audit_comment, to: :document

  before_validation :set_audit_comment, on: :create

  def revoke(revoked_by: user)
    AuditedOperationsService.revoke_share(share: self, user: revoked_by)
  end

  def access(accessed_by:)
    AuditedOperationsService.access_shared_document(
      share: self,
      user: accessed_by
    )
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

  def set_audit_comment
    self.audit_comment = share_audit_comment
  end
end
