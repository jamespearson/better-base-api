require "rails_helper"

RSpec.describe "V1::Users", type: :request do
  include AuthenticationTestHelper

  before(:each) do
    FactoryBot.create_list(:user, 10)
  end

  describe "GET /v1/users" do
    describe "as an unauthenticated user" do
      it "returns http unauthorized" do
        get v1_users_path
        expect(response).to have_http_status(401)
      end
    end

    describe "as a regular user" do
      before(:each) do
        @user = FactoryBot.create(:user)
        @headers = authentication_headers(@user)
      end

      it "returns http success" do
        get v1_users_path, headers: @headers
        expect(response).to have_http_status(200)
      end

      it "should only return the current user" do
        get v1_users_path, headers: @headers
        json = JSON.parse(response.body)
        expected_result = JSON.parse(UserSerializer.new([@user]).serializable_hash.to_json)

        expect(json).to eq(expected_result)
      end
    end

    describe "as an admin user" do
      before(:each) do
        @user = FactoryBot.create(:user, :admin)
        @headers = authentication_headers(@user)
      end

      it "returns http success" do
        get v1_users_path, headers: @headers
        expect(response).to have_http_status(200)
      end

      it "should return all users" do
        get v1_users_path, headers: @headers
        json = JSON.parse(response.body)
        expected_result = JSON.parse(UserSerializer.new(User.all).serializable_hash.to_json)

        expect(json).to eq(expected_result)
      end
    end
  end

  describe "GET /v1/users/:id" do
    it("should return the expected json") do
      user = FactoryBot.create(:user)
      headers = authentication_headers(user)

      get v1_user_path(user), headers: headers
      json = JSON.parse(response.body)
      expected_result = JSON.parse(UserSerializer.new(user).serializable_hash.to_json)

      expect(json).to eq(expected_result)
    end

    describe "as an unauthenticated user" do
      it "returns http unauthorized" do
        get v1_user_path(User.first)
        expect(response).to have_http_status(401)
      end
    end

    describe "as a regular user" do
      before(:each) do
        @user = FactoryBot.create(:user)
        @headers = authentication_headers(@user)
      end

      it "should allow you to view your own user" do
        get v1_user_path(@user), headers: @headers
        expect(response).to have_http_status(200)
      end

      it "should not allow you to view another user" do
        other_user = FactoryBot.create(:user)

        get v1_user_path(other_user), headers: @headers
        expect(response).to have_http_status(401)
      end
    end

    describe "as an admin user" do
      before(:each) do
        @user = FactoryBot.create(:user, :admin)
        @headers = authentication_headers(@user)
      end

      it "should allow you to view any user" do
        other_user = FactoryBot.create(:user)

        get v1_user_path(other_user), headers: @headers
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PUT /v1/users/:id" do
    describe "as an unauthenticated user" do
      it "returns http unauthorized" do
        put v1_user_path(User.first)
        expect(response).to have_http_status(401)
      end
    end

    describe "as a regular user" do
      before(:each) do
        @user = FactoryBot.create(:user)
        @headers = authentication_headers(@user)
      end

      describe "updating your own profile" do
        it "should allow you to update your own user" do
          new_email = "test@updated-test.com"

          expect(@user.email).to_not eq(new_email)

          patch v1_user_path(@user), headers: @headers, params: {user: {email: new_email}}.to_json

          expect(@user.reload.email).to eq(new_email)

          json = JSON.parse(response.body)
          expected_result = JSON.parse(UserSerializer.new(@user.reload).serializable_hash.to_json)

          expect(json).to eq(expected_result)
        end
      end

      describe "updating another user's profile" do
        it "should not be allowed" do
          other_user = FactoryBot.create(:user)
          new_email = "other@user.com"

          patch v1_user_path(other_user), headers: @headers, params: {user: {email: new_email}}.to_json

          expect(response).to have_http_status(401)
          expect(other_user.reload.email).to_not eq(new_email)
        end
      end
    end
  end
end
