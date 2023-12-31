class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include RoleModel

  audited except: [:jti]

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  roles :admin, :manager, :author, prefix: "is_"

  def jwt_payload
    super.merge("roles" => roles.to_a)
  end
end
