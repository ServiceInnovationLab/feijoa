# frozen_string_literal: true

class UserDocument < ApplicationRecord
  include Discard::Model

  audited associated_with: :user, comment_required: true

  belongs_to :user
  belongs_to :document, polymorphic: true

  def revoke_shares_and_discard!(audit_comment: document.class.remove_audit_comment)
    ActiveRecord::Base.transaction do
      revoke_associated_shares!
      update!(
        discarded_at: Time.now.utc,
        audit_comment: audit_comment
      )
    end
  end

  def revoke_associated_shares!
    Share.where(user: user, document: document).find_each(&:revoke)
  end
end
