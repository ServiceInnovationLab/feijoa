# frozen_string_literal: true

class OrganisationUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  has_many :user_shares, as: :recipient, dependent: :nullify
end
