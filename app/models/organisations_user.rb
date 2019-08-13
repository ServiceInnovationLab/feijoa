class OrganisationsUser < ApplicationRecord
  belongs_to :organisation
  belongs_to :user

  ADMIN_ROLE = 'admin'.freeze
  STAFF_ROLE = 'staff'.freeze

  ROLES = [ADMIN_ROLE, STAFF_ROLE]

  def is_admin?
    role == ADMIN_ROLE
  end

  def is_staff?
    role == STAFF_ROLE
  end
end
