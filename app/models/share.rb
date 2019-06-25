# frozen_string_literal: true

class Share < ApplicationRecord
  include Discard::Model
  self.discard_column = :revoked_at

  audited associated_with: :birth_record

  belongs_to :birth_record
  belongs_to :user

  belongs_to :recipient, polymorphic: true
  belongs_to :revoked_by, polymorphic: true, optional: true

  validates :user, presence: true
  validates :recipient, presence: true
  validates :birth_record, presence: true

  validates :birth_record_id,
            uniqueness: { scope: %i[recipient_id user_id recipient_type],
                          message: 'has already been shared with this entity' }

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
end
