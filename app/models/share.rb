# frozen_string_literal: true

class Share < ApplicationRecord
  audited associated_with: :birth_record

  belongs_to :user
  belongs_to :recipient, polymorphic: true
  belongs_to :birth_record

  validates :user, presence: true
  validates :recipient, presence: true
  validates :birth_record, presence: true

  validates :birth_record_id,
            uniqueness: { scope: %i[recipient_id user_id recipient_type],
                          message: 'has already been shared with this entity' }

  def revoke(revoked_by:)
    #TODO in another branch already?
  end
end
