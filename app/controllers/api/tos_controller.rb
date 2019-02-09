module Api
  class TosController < BaseController
    respond_to :json

    resource_description do
      name "Tos"
      short "Terms of Service"
    end

    api :GET,
        "/tos",
        "Read TOS"
    def show
      skip_policy_scope
      skip_authorization
    end

    private

    def api_resource
      SitePreference.by_key("tos")
    end

    def tos_content
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        autolink: true
      ).render(
        api_resource.content
      )
    end
    helper_method :tos_content
  end
end
