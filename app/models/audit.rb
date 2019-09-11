# frozen_string_literal: true

class Audit < Audited::Audit
  scope :viewing_birth_record, -> { where(comment: VIEW_SHARED_BIRTH_RECORD) }
  scope :sharing_birth_record, -> { where(comment: SHARE_BIRTH_RECORD) }

  scope :for_user_shares, lambda { |user|
    share_ids = user.shares.ids
    where(auditable_type: 'Share', auditable_id: share_ids)
  }

  CUSTOM_RENDERING_TYPES = %w[share user_document].freeze

  # constants for User/BirthRecord actions
  ADD_BIRTH_RECORD_TO_USER = 'ADD_BIRTH_RECORD_TO_USER'
  ADD_DOCUMENT_TO_USER = 'ADD_DOCUMENT_TO_USER'
  REMOVE_BIRTH_RECORD_FROM_USER = 'REMOVE_BIRTH_RECORD_FROM_USER'
  REMOVE_DOCUMENT_FROM_USER = 'REMOVE_DOCUMENT_FROM_USER'
  UPDATE_DOCUMENT = 'UPDATE_DOCUMENT'

  # constants for User/Share actions
  SHARE_BIRTH_RECORD = 'SHARE_BIRTH_RECORD'
  SHARE_DOCUMENT = 'SHARE_DOCUMENT'
  REVOKE_SHARE = 'REVOKE_SHARE'

  # constants for Recipient/Share actions
  VIEW_SHARED_BIRTH_RECORD = 'VIEW_SHARED_BIRTH_RECORD'
  VIEW_SHARED_DOCUMENT = 'VIEW_SHARED_DOCUMENT'

  # Override the default partial path generator so we can render appropriate
  # different partials for each kind of audit
  #
  # This looks for partials based on the type of record associated with the
  # audit (UserDocument, Share, View) in an appropriately named file, e.g.
  # /audits/_share.html.erb
  #
  # Note that for namespaced controllers (User::SharesController) the partial
  # search path will also be automatically namespaced by Rails
  # (/views/user/audit/_share.html.erb). There is an option to disable that
  # application-wide if necessary, see
  # `Rails.application.config.action_view.prefix_partial_path_with_controller_namespace = false`
  def to_partial_path
    return "shared/audits/#{auditable_type.underscore}" if custom_rendering?

    'shared/audits/audit'
  end

  private

  def custom_rendering?
    CUSTOM_RENDERING_TYPES.include?(auditable_type.underscore)
  end
end
