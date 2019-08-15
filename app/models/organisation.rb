# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :shares, as: :recipient
  has_many :organisation_members, dependent: :destroy
  has_many :users, through: :organisation_members

  def add_admin(user)
    organisation_members.create(user: user, role: OrganisationMember::ADMIN_ROLE)
  end

  def add_staff(user)
    organisation_members.create(user: user, role: OrganisationMember::ADMIN_ROLE)
  end
end
