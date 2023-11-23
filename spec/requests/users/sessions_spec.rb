require "rails_helper"
require "jwt"

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /login" do
    describe "with valid credentials" do
      setup do
        @user = FactoryBot.create(:user)
      end
      it("should login with a valid username / password") do
        post "/login", params: {user: {email: @user.email, password: @user.password}}

        expect(response).to have_http_status(:success)

        json = JSON.parse(response.body)
        expect(json).to eq({"data" => {"id" => @user.id, "type" => "user", "attributes" => {"id" => @user.id, "email" => @user.email}}})
      end

      it("should return a JWT in the headers") do
        post "/login", params: {user: {email: @user.email, password: @user.password}}

        expect(response).to have_http_status(:success)
        expect(response.headers["Authorization"]).to be_present

        jwt = JWT.decode(response.headers["Authorization"].split(" ").last, nil, false).first
        expect(jwt["sub"]).to eq(@user.id)
      end
    end

    it("should not login without an invalid email / password") do
      user = FactoryBot.create(:user)
      post "/login", params: {user: {email: user.email, password: "not-the-password"}}

      expect(response).to have_http_status(:unauthorized)

      json = JSON.parse(response.body)
      expect(json["status"]["code"]).to eq(401)
      expect(json["status"]["message"]).to eq("Invalid Email or password.")

      expect(json["data"]).to eq({})
    end

    it("should not login without a username") do
      post "/login", params: {user: {
        password: "not-the-password"
      }}

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(json["status"]["message"]).to eq("You need to sign in or sign up before continuing.")
    end

    it("should not login without a password") do
      user = FactoryBot.create(:user)
      post "/login", params: {user: {
        email: user.email
      }}

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(json["status"]["message"]).to eq("Invalid Email or password.")
    end
  end
end
