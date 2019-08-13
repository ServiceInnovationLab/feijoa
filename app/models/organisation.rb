class Organisation < ApplicationRecord
  has_many :shares, as: :recipient
  has_many :organisations_users
  has_many :users, through: :organisations_users

  def add_admin(user)
    organisations_users.create(user: user, role: OrganisationsUser::ADMIN_ROLE)
  end

  def add_staff(user)
    organisations_users.create(user: user, role: OrganisationsUser::ADMIN_ROLE)
  end
end
