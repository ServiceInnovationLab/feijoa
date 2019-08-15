# frozen_string_literal: true

class SharePolicy
  attr_reader :share, :user

  def initialize(user, share)
    @user = user
    @share = share
  end

  def show?
    user == share.user || user.member_of?(share.recipient)
  end

  def update?
    user == share.user || user.admin_for?(share.recipient)
  end

  def destroy?
    user == share.user
  end
end