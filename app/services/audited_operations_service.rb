# frozen_string_literal: true

# A service which provides a wrapper around business logic which must be audited (record which user took the action)
class AuditedOperationsService
  def self.add_birth_record_to_user(user:, birth_record:)
    raise ArgumentError, 'user cannot be nil' if user.nil?
    raise ArgumentError, 'birth_record cannot be nil' if birth_record.nil?

    Audited.audit_class.as_user(user) do
      user.birth_records << birth_record
    end
  end

  def self.remove_birth_record_from_user(user:, birth_record_id:)
    raise ArgumentError, 'user cannot be nil' if user.nil?

    Audited.audit_class.as_user(user) do
      begin
        user
          .birth_records_users
          .find_by!(birth_record_id: birth_record_id)
          .discard

      rescue ActiveRecord::RecordNotFound
        return false
      end
    end
  end

  def self.share_birth_record_with_recipient(user:, birth_record:, recipient:)
    raise ArgumentError, 'user cannot be nil' if user.nil?
    raise ArgumentError, 'birth_record cannot be nil' if birth_record.nil?
    raise ArgumentError, 'recipient cannot be nil' if recipient.nil?

    Audited.audit_class.as_user(user) do
      Share.create!(user: user, birth_record: birth_record, recipient: recipient)
    end
  end

  def self.revoke_share(user:, share:)
    raise ArgumentError, 'user cannot be nil' if user.nil?

    Audited.audit_class.as_user(user) do
      share.revoke(revoked_by: user)
    end
  end
end
