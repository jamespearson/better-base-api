require "rails_helper"

class UserPolicyTest < ActiveSupport::TestCase
  describe "UserPoicy::Scope" do
    setup do
      FactoryBot.create_list(:user, 10)
    end
    describe "when the user is an admin" do
      setup do
        @user = FactoryBot.create(:user, :admin)
        @scope = UserPolicy::Scope.new(@user, User).resolve
      end

      it("should return all users") do
        assert_equal User.all, @scope
      end
    end

    describe "when the user is not an admin" do
      setup do
        @user = FactoryBot.create(:user)
        @scope = UserPolicy::Scope.new(@user, User).resolve
      end

      it("should return only the current user") do
        assert_equal [@user], @scope
      end
    end
  end

  describe "when updating a user" do
    setup do
      @user = FactoryBot.create(:user)
    end

    describe "when the user is a regular user" do
      it("should allow the user to update themselves") do
        assert UserPolicy.new(@user, @user).update?
      end

      it("should not allow a user to update another user") do
        assert !UserPolicy.new(@user, FactoryBot.create(:user)).update?
      end
    end

    describe "when the user is an admin" do
      setup do
        @admin = FactoryBot.create(:user, :admin)
      end

      it("should allow the admin to update themselves") do
        assert UserPolicy.new(@admin, @admin).update?
      end

      it("should allow the admin to update another user") do
        assert UserPolicy.new(@admin, FactoryBot.create(:user)).update?
      end
    end
  end
end
