module Api
  class PusherAuthsController < BaseController
    respond_to :json

    skip_after_action :update_auth_header

    def create
      if pundit_user && pundit_authorize
        response = Pusher.authenticate(
          params[:channel_name],
          params[:socket_id]
        )
        render json: response
      else
        skip_policy_scope
        skip_authorization
        render text: 'Forbidden', status: '403'
      end
    end

    private

    def pundit_authorize
      authorize api_resource, :show?
    end

    def api_resource
      model_name, id = params[:channel_name].split("-").last.split(".")
      policy_scope(model_name.classify.constantize).find(id)
    end
  end
end
