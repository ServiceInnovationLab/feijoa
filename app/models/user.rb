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
