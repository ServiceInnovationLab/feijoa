# frozen_string_literal: true

# DEPRECATED
class OrganisationUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  has_many :shares, as: :recipient, dependent: :nullify
end
