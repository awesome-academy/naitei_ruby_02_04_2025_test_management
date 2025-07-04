module Api
  module V1
    class SubjectsController < Api::V1::ApplicationController
      load_and_authorize_resource only: %i(show)

      def index
        @subjects = Subject.latest

        render json: @subjects
      end

      def show
        render json: @subject
      end
    end
  end
end
