# frozen_string_literal: true

class Share < ApplicationRecord
  include Discard::Model
  self.discard_column = :revoked_at

  audited associated_with: :user, comment_required: true

  belongs_to :birth_record
  belongs_to :user

  belongs_to :recipient, polymorphic: true
  belongs_to :revoked_by, polymorphic: true, optional: true

  validates :user, presence: true
  validates :recipient, presence: true
  validates :birth_record, presence: true

  validate :not_currently_shared, on: :create

  # Revoke this share, so the recipient can no longer view the shared birth
  # record
  #
  # This records who revoked the share (usually the user who initiated it, but
  # it could be voluntarily given up by the recipient for example), and does a
  # soft-delete (using the 'discard' gem) which saves a timestamp into the
  # revoked_at column
  def revoke(revoked_by:)
    update!(
      revoked_by: revoked_by,
      revoked_at: Time.now.utc
    )
  end

  def revoked?
    revoked_by.present?
  end

  private

  # True if the user doesn't have any active (not soft deleted) shares of this
  # birth record with this recipient
  def not_currently_shared
    if Share.where(recipient: recipient, user: user, birth_record: birth_record).kept.any?
      errors.add(:recipient, 'is currently shared with this entity')
    end
  end
end
