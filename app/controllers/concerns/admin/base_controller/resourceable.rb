module Admin
  class BaseController < ::ApplicationController
    module Resourceable
      extend ActiveSupport::Concern

      included do
        helper_method :pundit_policy
        cattr_accessor :resource_type
      end

      def show
        find_current_resource
        pundit_authorize
      end

      def edit
        find_current_resource
        pundit_authorize
      end

      def new
        new_current_resource
        pundit_authorize
      end

      def create
        new_current_resource
        pundit_authorize
        if @current_resource.save
          redirect_to(
            resource_path,
            success: t("admin.#{resource_type.underscore}.created")
          )
        else
          render :new
        end
      end

      def update
        find_current_resource
        pundit_authorize
        if @current_resource.update(resource_params)
          redirect_to(
            resource_path,
            notice: t("admin.#{resource_type.underscore}.updated")
          )
        else
          render :edit
        end
      end

      protected

      def find_current_resource
        @current_resource = resource_scope.find(params[:id]).decorate
      end

      def new_current_resource
        @current_resource = resource_scope.new(resource_params).decorate
      end

      def resource_scope
        skip_policy_scope
        pundit_policy_class::Scope.new(
          pundit_user,
          resource_collection_for_scope
        ).resolve
      end

      def resource_collection_for_scope
        resource_klass
      end

      def resource_params
        params.require(
          resource_type.underscore
        ).permit(
          pundit_policy.permitted_attributes
        ) if params[resource_type.underscore].present?
      end

      def pundit_authorize
        arguments = [ "#{action_name}?" ]
        arguments << params[:predicate] if params[:predicate].present?
        if pundit_policy.send(*arguments)
          skip_authorization
        else
          raise Pundit::NotAuthorizedError
        end
      end

      def pundit_policy
        @pundit_policy ||= pundit_policy_class.new(
          pundit_user,
          @current_resource.presence || resource_klass
        )
      end

      def pundit_policy_class
        "Admin::#{resource_type}Policy".constantize
      end

      def resource_klass
        resource_type.constantize
      end

      def resource_path
        { action: :show,
          id: @current_resource.id }
      end
    end
  end
end
