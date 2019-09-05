# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable, :invitable

  has_many :user_documents, dependent: :nullify
  has_many :birth_records, -> { distinct.merge(UserDocument.kept) },
           through: :user_documents,
           source: :document, source_type: Document::BIRTH_RECORD
  has_many :immunisation_records, -> { distinct.merge(UserDocument.kept) },
           through: :user_documents,
           source: :document, source_type: Document::IMMUNISATION_RECORD

  has_many :shares, -> { merge(Share.kept) }, dependent: :nullify, inverse_of: :user

  has_many :organisation_members, dependent: :destroy
  has_many :organisations, through: :organisation_members

  has_many :requests, inverse_of: :requestee, foreign_key: 'requestee_id', dependent: :destroy
  has_many :audits, dependent: :nullify

  def self.find_or_invite(email)
    user = find_by(email: email)
    return user if user.present?

    invite!(email: email)
  end

  # Janitor = Global admin
  JANITOR_ROLE = 'janitor'

  def janitor?
    global_role == JANITOR_ROLE
  end

  def role_for(organisation)
    return nil unless member_of?(organisation)

    organisation_members.find_by(organisation: organisation).role
  end

  def admin_for?(organisation)
    role_for(organisation) == OrganisationMember::ADMIN_ROLE
  end

  def member_of?(organisation)
    organisations.include? organisation
  end

  def documents(type: nil)
    return birth_records if type.to_s == Document::BIRTH_RECORD
    return immunisation_records if type.to_s == Document::IMMUNISATION_RECORD
    return birth_records + immunisation_records if type.nil?

    []
  end

  def add_role(organisation, role)
    OrganisationMember.create!(
      user: self,
      organisation: organisation,
      role: role
    )
  end
end
