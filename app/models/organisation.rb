# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :shares, as: :recipient, dependent: :destroy
  has_many :organisation_members, dependent: :destroy
  has_many :users, through: :organisation_members
  has_many :requests, inverse_of: 'requester', foreign_key: 'requester_id', dependent: :destroy

  validates :name, presence: true
  validates :data_source_key, uniqueness: { scope: :data_source_name }, allow_nil: true

  def add_admin(user)
    organisation_members.create(user: user, role: OrganisationMember::ADMIN_ROLE)
  end

  def add_staff(user)
    organisation_members.create(user: user, role: OrganisationMember::ADMIN_ROLE)
  end
end
