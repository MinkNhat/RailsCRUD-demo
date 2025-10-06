class UserPolicy < ApplicationPolicy
  def create?
    user.super_admin?
  end
end
