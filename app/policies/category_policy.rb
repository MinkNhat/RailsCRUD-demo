class CategoryPolicy < ApplicationPolicy
  def index?
    user.super_admin? || user.admin? || user.content_manager?
  end

  alias_method :show?, :index?
  alias_method :create?, :index?
  alias_method :update?, :index?

  def destroy?
    user.super_admin? || user.admin?
  end
end
