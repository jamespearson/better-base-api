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
        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(expected_user_response(@created_user))
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
    end

    it("should not signup a duplicate user") do
      user = FactoryBot.create(:user)

      post "/signup", params: {user: {email: user.email, password: user.password}}
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)

      expect(json).to eq(
        {"errors" => [
          {
            "status" => "422",
            "title" => "Invalid request",
            "detail" => ["has already been taken"],
            "source" => {"pointer" => "/data/attributes/email"}
          }
        ]}
      )
    end

    private

    def expected_user_response(user)
      JSON.parse(CurrentUserSerializer.new(user).serializable_hash.to_json).deep_symbolize_keys
    end
  end
end
