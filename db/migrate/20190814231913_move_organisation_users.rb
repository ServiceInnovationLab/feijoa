class MoveOrganisationUsers < ActiveRecord::Migration[5.2]
  def up
    OrganisationUser.all.each do |organisation_user|
      organisation = Organisation.find_or_create_by(name: organisation_user.email)
      organisation_user.shares.each do |share|
        share.recipient = organisation
        share.save(validate: false)
      end
      unless User.where(email: organisation_user.email).any?
        user = User.create(email: organisation_user.email, password: SecureRandom.hex(10))
        organisation.add_admin(user)
      end
    end
  rescue NameError
    # if OrganisationUser is not defined, this is being run
    # after the OrganisationUser model has beeen deleted
    # and it doesn't have anything to do. Cool
  end

  def down
    # irreversible migration
  end
end
