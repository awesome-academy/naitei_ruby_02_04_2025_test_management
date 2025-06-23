module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token, raise: false

      def create
        if current_user
          render json: { error: 'You are already logged in' }, status: :forbidden
          return
        end

        if User.exists?(email: user_params[:email].downcase)
          render json: { error: 'Email already exists' }, status: :unprocessable_entity and return
        end

        if user_params[:password] != user_params[:password_confirmation]
          render json: { error: 'Password confirmation does not match' }, status: :unprocessable_entity and return
        end

        @user = User.new user_params

        if @user.save
          token = JsonWebToken.encode(user_id: @user.id)
          render json: { token: token, user: @user.as_json(except: :password_digest) }, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private
      def user_params
        params.require(:user).permit(User::USER_ATTR)
      end
    end
  end
end
