# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  has_many :birth_records_users, dependent: :nullify
  has_many :birth_records, -> { distinct.merge(BirthRecordsUser.kept) }, through: :birth_records_users
  has_many :shares, -> { merge(Share.kept) }, dependent: :nullify, inverse_of: :user

  has_many :organisation_members, dependent: :destroy
  has_many :organisations, through: :organisation_members

  # Janitor = Global admin
  JANITOR_ROLE = 'janitor'

  def janitor?
    global_role == JANITOR_ROLE
  end

  def role_for(organisation)
    return nil unless member_of?(organisation)

    organisation_members.find(organisation: organisation).role
  end

  def admin_for?(organisation)
    role_for(organisation) == OrganisationMember::ADMIN_USER
  end

  def member_of?(organisation)
    organisations.include? organisation
  end

  # Get the audits for this user
  #
  # These are audits where the user is the one who took action. Notably this
  # doesn't include audits where an organisation views a birth record shared by
  # this use (because the organisation takes the action). Those audits can be
  # retrieved separately with `user.shares.map(&:audits).flatten` - see
  # User::AuditsController#index for an implementation
  def audits
    Audit.where(user: self)
  end
end
