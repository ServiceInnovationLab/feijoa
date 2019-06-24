# frozen_string_literal: true

Audited.config do |config|
  # This defaults to :current_user, but needs to be overridden due to our multiple
  # user models.
  config.current_user_method = :current_account

  # We extend the default Audit model slightly with our own class
  config.audit_class = Audit
end
