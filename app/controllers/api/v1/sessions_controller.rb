module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token, raise: false

      LOGIN_PARAMS = [
        :email,
        :password,
      ].freeze

      def create
        user = User.find_by email: login_params[:email].downcase
        if user&.authenticate(login_params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user.as_json(except: :password_digest) }, status: :created
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
          return
        end
      end

      private
      def login_params
        params.require(:session).permit(LOGIN_PARAMS)
      end
    end
  end
end
