module Api
  module V1
    class Supervisor::SubjectsController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token, raise: false
      before_action :authenticate_request
      load_and_authorize_resource only: %i(create update destroy)

      def create
        if @subject.save
          render json: @subject, status: :created
        else
          render json: @subject.errors, status: :unprocessable_entity
        end
      end

      def update
        if @subject.update(subject_params)
          render json: @subject, status: :ok
        else
          render json: @subject.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @subject.exam
          render json: { error: t(".has_exams") }, status: :unprocessable_entity
        elsif @subject.destroy
          render json: { message: t(".success") }, status: :ok
        else
          render json: { error: t(".error") }, status: :unprocessable_entity
        end
      end

      private

      def subject_params
        params.require(:subject).permit Subject::SUBJECT_ATTRS
      end
    end
  end
end
