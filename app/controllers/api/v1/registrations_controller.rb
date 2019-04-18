module Api::V1
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_request

    def create
      build_resource(sign_up_params)
      resource.save
      yield resource if block_given?
      if resource.persisted?
        command = AuthenticateUser.call(params[:user][:email], params[:user][:password])
        render json: {status: "success", user: resource,auth_token: command.result}
      else
        msg = resource.errors.messages
        error_msg = check_errors(msg)
        render json: {status: "failed", error: error_msg}
      end
    end

    def check_errors(msg)
      if msg[:email].present? && msg[:password_confirmation].present?
        error_msg = "email has already been taken and doesn't match Password"
      elsif msg[:email].present?
        error_msg = "email has already been taken"
      elsif msg[:password_confirmation].present?
        error_msg = "doesn't match Password"
      end
    end
  end
end