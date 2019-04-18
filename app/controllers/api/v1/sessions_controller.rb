module Api::V1
  class SessionsController < ApplicationController
    respond_to :json
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_request

    before_action :ensure_params_exist, only: [:create]

    def create
      command = AuthenticateUser.call(params[:user][:email], params[:user][:password])
      if command.success?
       render json: { auth_token: command.result }
      else
       render json: { error: command.errors }, status: :unauthorized
      end
    end
    protected

      def ensure_params_exist
        return unless params[:user].blank?
        render json: {status: "failed", error: "Missing User Parameter"}
      end

      def invalid_login_attempt
        warden.custom_failure!
        render json: {status: "failed", error: "Error with your Email or password"}
      end

  end
end