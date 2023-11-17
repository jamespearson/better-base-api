class CustomFailure < Devise::FailureApp
  def respond
    self.status = 401
    self.content_type = "application/json"
    self.response_body = {
      status: {
        code: status,
        message: http_auth? ? http_auth : "Unauthorized"
      },
      data: {}
    }.to_json
  end
end
