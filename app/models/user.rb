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
  # BirthRecordsUser (the join table), Share, and View (TODO not implemented
  # yet, requires the 'view shared birth records' feature) audits are all
  # associated with a BirthRecord so the easiest way to gat a user's audits is
  # to get the associated audits for their birth records.
  def audits
    Audit.where(user: self)
  end
end
