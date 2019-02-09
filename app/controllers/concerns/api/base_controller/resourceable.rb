module Api
  class BaseController < ::ApplicationController
    module Resourceable
      def show
        find_api_resource
        pundit_authorize_resource
        render resource_template
      end

      def create
        new_api_resource
        pundit_authorize_resource
        if @api_resource.save
          after_create_api_resource
          render resource_template, status: :created
        else
          render_resource_error
        end
      end

      def update
        find_api_resource
        pundit_authorize_resource
        if @api_resource.update(resource_params)
          after_update_api_resource
          render resource_template, status: :accepted
        else
          render_resource_error
        end
      end

      def destroy
        find_api_resource
        pundit_authorize_resource
        @api_resource.send resource_destruction_method
        resource_destruction_response
      end

      protected

      def render_resource_error
        render "api/shared/resource_error",
               status: :unprocessable_entity
      end

      def resource_destruction_response
        head :no_content
      end

      def resource_destruction_method
        :destroy
      end

      def find_api_resource
        @api_resource ||= resource_scope.find(params[:id])
      end

      def new_api_resource
        @api_resource ||= resource_scope.new(resource_params)
      end

      def resource_params
        params.permit(
          *policy(resource_klass).permitted_attributes
        )
      end

      def resource_template
        resource_klass.to_s.underscore.to_sym
      end

      def pundit_authorize_resource
        authorize(@api_resource)
      end

      def after_update_api_resource
        # to implement callbacks
      end

      def after_create_api_resource
        # to implement callbacks
      end
    end
  end
end
