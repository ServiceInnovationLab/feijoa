# frozen_string_literal: true

class OrganisationMember < ApplicationRecord
  belongs_to :organisation
  belongs_to :user

  ADMIN_ROLE = 'admin'
  STAFF_ROLE = 'staff'

  ROLES = [ADMIN_ROLE, STAFF_ROLE].freeze

  def admin?
    role == ADMIN_ROLE
  end

  def staff?
    role == STAFF_ROLE
  end
end
