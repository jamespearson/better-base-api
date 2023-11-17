class UserPolicy < ApplicationPolicy
  # Only admins or the user itself can update a record.
  def update?
    user.is_admin? || user.id == record.id
  end

  class Scope < Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.is_admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end

    private

    attr_reader :user, :scope
  end
end
