# frozen_string_literal: true

class OrganisationPolicy < ApplicationPolicy
  def create?
    @user.janitor?
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    @user.admin_for?(@record) || @user.janitor?
  end

  def destroy?
    @user.janitor?
  end

  def dashboard?
    act_as?
  end

  def act_as?
    @user.member_of?(@record)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
