class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  # before_action :configure_sign_in_params, only: [:create]
  respond_to :json

  skip_after_action :verify_authorized

  private

  def respond_with(current_user, _opts = {})
    render json: UserSerializer.new(current_user).serializable_hash, status: :ok
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload["sub"])
    end

    if current_user
      render json: UserSerializer.new(current_user).serializable_hash, status: :ok
    else
      raise JsonapiErrorsHandler::Errors::NotFound
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
