# frozen_string_literal: true

class Share < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, polymorphic: true
  belongs_to :birth_record
  belongs_to :revoker, polymorphic: true, required: false

  validates :user, presence: true
  validates :recipient, presence: true
  validates :birth_record, presence: true

  scope :active, -> { where(revoked?: false) }
  scope :revoked, -> { where(revoked?: true) }

  def revoked?
    revoker.present?
  end

  def revoke(account)
    # consider business logic for who can revoke a share. The expected case is
    # the user who created the share originally, but it could also be the
    # recipient, an admin?, or even the subject of the birth record if it was
    # originally shared by a parent

    update!(
      revoker: account,
      revoked_at: Time.now.utc
    )
  end
end
