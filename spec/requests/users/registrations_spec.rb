require "rails_helper"

RSpec.describe "RegistrationControllers", type: :request do
  describe "POST /signup" do
    describe "with valid credentials" do
      setup do
        @user = FactoryBot.build(:user)
      end
      it("should login with a valid username / password") do
        post "/signup", params: {user: {email: @user.email, password: @user.password}}

        expect(response).to have_http_status(:success)

        @created_user = User.find_by(email: @user.email)

        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(200)
        expect(json["status"]["message"]).to eq("Signed up successfully.")

        expected_data = JSON.parse(UserSerializer.new(@created_user).serializable_hash[:data].to_json).deep_symbolize_keys
        expect(json["data"].deep_symbolize_keys).to eq(expected_data)
      end

      it("should return a JWT in the headers") do
        post "/signup", params: {user: {email: @user.email, password: @user.password}}

        expect(response).to have_http_status(:success)
        expect(response.headers["Authorization"]).to be_present

        @created_user = User.find_by(email: @user.email)
        jwt = JWT.decode(response.headers["Authorization"].split(" ").last, nil, false).first
        expect(jwt["sub"]).to eq(@created_user.id)
      end
    end

    it("should not signup without an invalid email / password") do
      post "/signup", params: {user: {email: "john", password: "not-the-password"}}
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["status"]["code"]).to eq(422)
      expect(json["status"]["message"]).to eq("User couldn't be created successfully. Email is invalid")
    end

    it("should not signup a duplicate user") do
      user = FactoryBot.create(:user)

      post "/signup", params: {user: {email: user.email, password: user.password}}
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)

      expect(json["status"]["code"]).to eq(422)
      expect(json["status"]["message"]).to eq("User couldn't be created successfully. Email has already been taken")
    end
  end
end
