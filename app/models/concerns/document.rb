# frozen_string_literal: true

require 'active_support/concern'

module Document
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    has_many :user_documents, dependent: :nullify
    has_many :users, -> { distinct }, through: :user_documents
    has_many :shares, -> { merge(Share.kept) }, dependent: :nullify, inverse_of: :document, foreign_key: 'document_id'

    def heading
      to_s
    end

    def document_type
      self.class.to_s
    end

    def add_to(user)
      user_documents.create(user: user)
    end

    def remove_from(user)
      ud = user_documents.find_by(user: user)
      return nil if ud.blank?

      ud.update(
        discarded_at: Time.now.utc,
        audit_comment: 'REMOVE_DOCUMENT_FROM_USER'
      )
    end

    def share_with(recipient:, user:)
      Share.create(
        user: user,
        document: self,
        recipient: recipient,
        audit_comment: 'SHARE_DOCUMENT'
      )
    end
  end

  class_methods do
    def document_type
      to_s
    end
  end
end
