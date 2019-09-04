# frozen_string_literal: true

Audited.config do |config|
  # We extend the default Audit model slightly with our own class
  config.audit_class = Audit
end
