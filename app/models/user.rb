class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include RoleModel

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    {"roles" => roles.to_a}
  end
end
