# frozen_string_literal: true

class OrganisationPolicy
  attr_reader :organisation, :user

  def initialize(user, organisation)
    @user = user
    @organisation = organisation
  end

  def index?
    true
  end

  def create?
    user.janitor?
  end

  def show?
    true
  end

  def update?
    user.admin_for?(organisation) || user.janitor?
  end

  def destroy?
    user.janitor?
  end
end
