# frozen_string_literal: true

require 'active_support/concern'

module Document
  extend ActiveSupport::Concern
  IMMUNISATION_RECORD = 'ImmunisationRecord'
  BIRTH_RECORD = 'BirthRecord'
  DOCUMENT_TYPES = [IMMUNISATION_RECORD, BIRTH_RECORD].freeze

  included do # rubocop:disable Metrics/BlockLength
    has_many :user_documents, dependent: :nullify, as: :document
    has_many :users, -> { distinct }, through: :user_documents
    has_many :shares, -> { merge(Share.kept) }, as: :document, dependent: :nullify,
                                                inverse_of: :document, foreign_key: 'document_id'

    delegate :share_audit_comment, :remove_audit_comment, :add_audit_comment,
             :view_audit_comment, :update_audit_comment, to: :class

    def immunisation_record?
      document_type == IMMUNISATION_RECORD
    end

    def birth_record?
      document_type == BIRTH_RECORD
    end

    def heading
      to_s
    end

    def document_type
      self.class.to_s
    end

    def add_to(user)
      user_documents.create(
        user: user,
        audit_comment: self.class.add_audit_comment
      )
    end

    def remove_from(user)
      ud = user_documents.find_by(user: user)
      return nil if ud.blank?

      ud.revoke_shares_and_discard!
    end

    def share_with(recipient:, user:)
      Share.create(
        user: user,
        document: self,
        recipient: recipient,
        audit_comment: self.class.share_audit_comment
      )
    end

    def to_partial_path
      "shared/documents/#{self.class.to_s.underscore}"
    end

    def shared_with?(user)
      return true if users.include?(user)

      recipients = shares.map(&:recipient)
      return true if recipients.include?(user)

      recipients.each do |recipient|
        return true if user.member_of?(recipient)
      end

      false
    end
  end

  class_methods do
    def document_type
      to_s
    end

    def share_audit_comment
      Audit::SHARE_DOCUMENT
    end

    def remove_audit_comment
      Audit::REMOVE_DOCUMENT_FROM_USER
    end

    def add_audit_comment
      Audit::ADD_DOCUMENT_TO_USER
    end

    def view_audit_comment
      Audit::VIEW_SHARED_DOCUMENT
    end

    def update_audit_comment
      Audit::UPDATE_DOCUMENT
    end
  end
end
