# frozen_string_literal: true

# A service which provides a wrapper around business logic which must be audited (record which user took the action)
class AuditedOperationsService
  class ShareRevokedError < StandardError
  end
  class UnauthorisedAccessRequestError < StandardError
  end

  def self.add_birth_record_to_user(user:, birth_record:)
    raise ArgumentError, 'user cannot be nil' if user.nil?

    Audited.audit_class.as_user(user) do
      user.user_documents << UserDocument.create!(
        user: user,
        document: birth_record,
        audit_comment: Audit::ADD_BIRTH_RECORD_TO_USER
      )
    end
  end

  def self.remove_birth_record_from_user(user:, birth_record_id:)
    raise ArgumentError, 'user cannot be nil' if user.nil?

    Audited.audit_class.as_user(user) do
      begin
        user
          .user_documents
          .find_by!(document_id: birth_record_id)
          .update!(
            discarded_at: Time.now.utc,
            audit_comment: Audit::REMOVE_BIRTH_RECORD_FROM_USER
          )
      rescue ActiveRecord::RecordNotFound
        return false
      end
    end
  end

  def self.share_birth_record_with_recipient(user:, birth_record:, recipient:)
    raise ArgumentError, 'user cannot be nil' if user.nil?

    Audited.audit_class.as_user(user) do
      Share.create!(
        user: user,
        document: birth_record,
        recipient: recipient,
        audit_comment: Audit::SHARE_BIRTH_RECORD
      )
    end
  end

  def self.revoke_share(user:, share:)
    raise ArgumentError, 'user cannot be nil' if user.nil?

    Audited.audit_class.as_user(user) do
      share.update!(
        revoked_by: user,
        revoked_at: Time.now.utc,
        audit_comment: Audit::REVOKE_SHARE
      )
    end
  end

  def self.access_shared_birth_record(logged_identity:, share:)
    raise ArgumentError, 'share cannot be nil' if share.nil?
    raise ArgumentError, 'logged_identity cannot be nil' if logged_identity.nil?
    raise ShareRevokedError if share.revoked?

    # update last_accessed_at, which will generate an audit record
    Audited.audit_class.as_user(logged_identity) do
      share.update!(
        last_accessed_at: Time.now.utc,
        audit_comment: Audit::VIEW_SHARED_BIRTH_RECORD
      )
    end

    # In a real system this would be a call to the DIA birth register API.
    # We are faking this so the record is already available.

    # logged_identity would be recorded in the BDM register access logs
    # official birth record would be returned here
    share.document
  end
end
