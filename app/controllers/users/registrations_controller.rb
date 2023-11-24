class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  skip_after_action :verify_authorized
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: CurrentUserSerializer.new(current_user).serializable_hash
    else
      mapped = JsonapiErrorsHandler::Errors::Invalid.new(errors: current_user.errors.messages)
      render_error(mapped)
    end
  end
end
