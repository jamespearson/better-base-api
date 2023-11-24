require "devise/jwt/test_helpers"

module AuthenticationTestHelper
  # This method is used inside the tests to authenticate the user
  def authentication_headers(user)
    headers = {"Accept" => "application/json", "Content-Type" => "application/json"}
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
