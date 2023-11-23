class ApplicationController < ActionController::API
  include Pundit::Authorization
  include JsonapiErrorsHandler

  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

  rescue_from ActionController::ParameterMissing, with: lambda { |e| handle_param_missing_error(e) }

  rescue_from ActiveRecord::RecordNotFound, with: lambda { |e| handle_validation_error(e) }
  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e|
                                                   handle_validation_error(e)
                                                 }
  rescue_from ActiveModel::ValidationError, with: lambda { |e|
    handle_validation_error(e)
  }

  def handle_param_missing_error(error)
    clean_backtrace = Rails.backtrace_cleaner.clean(error.backtrace)

    processed_error = {
      title: "#{error.param} is missing or the value is empty",
      status: 400,
      message: "#{error.param} is missing or the value is empty",
      source: clean_backtrace.last.split(".rb").first
    }

    render json: {errors: [processed_error]}.to_json, status: 400
  end

  def handle_validation_error(error)
    messages = error.try(:record).try(:errors).try(:messages) || error.try(:messages) || error.try(:message)
    mapped = JsonapiErrorsHandler::Errors::Invalid.new(errors: [*messages])
    render_error(mapped)
  end

  after_action :verify_authorized
end
