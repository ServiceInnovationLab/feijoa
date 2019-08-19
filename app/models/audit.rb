# frozen_string_literal: true

class Audit < Audited::Audit
  scope :viewing_birth_record, ->() { where(comment: AuditedOperationsService::VIEW_SHARED_BIRTH_RECORD) }
  scope :sharing_birth_record, ->() { where(comment: AuditedOperationsService::SHARE_BIRTH_RECORD) }
  CUSTOM_RENDERING_TYPES = %w[share birth_records_user].freeze

  # Override the default partial path generator so we can render appropriate
  # different partials for each kind of audit
  #
  # This looks for partials based on the type of record associated with the
  # audit (BirthRecordsUser, Share, View) in an appropriately named file, e.g.
  # /audits/_share.html.erb
  #
  # Note that for namespaced controllers (User::SharesController) the partial
  # search path will also be automatically namespaced by Rails
  # (/views/user/audit/_share.html.erb). There is an option to disable that
  # application-wide if necessary, see
  # `Rails.application.config.action_view.prefix_partial_path_with_controller_namespace = false`
  def to_partial_path
    return "audits/#{auditable_type.underscore}" if custom_rendering?

    'audits/audit'
  end

  private

  def custom_rendering?
    CUSTOM_RENDERING_TYPES.include?(auditable_type.underscore)
  end
end
