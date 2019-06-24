# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  has_many :birth_records_users, dependent: :destroy
  has_many :birth_records, -> { distinct }, through: :birth_records_users
  has_many :shares, dependent: :nullify

  # Get the audits for this user
  #
  # BirthRecordsUser (the join table), Share, and View (TODO not implemented
  # yet, requires the 'view shared birth records' feature) audits are all
  # associated with a BirthRecord so the easiest way to gat a user's audits is
  # to get the associated audits for their birth records.
  def audits
    birth_records
      .map(&:associated_audits)
      .flatten
      .select { |a| a.user_id == id && a.user_type == self.class.name }
  end
end
