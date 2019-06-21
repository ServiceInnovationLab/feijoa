# frozen_string_literal: true

class User < ApplicationRecord
  audited
  has_associated_audits

  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  has_many :birth_records_users, dependent: :destroy
  has_many :birth_records, -> { distinct}, through: :birth_records_users
  has_many :shares, dependent: :nullify
end
