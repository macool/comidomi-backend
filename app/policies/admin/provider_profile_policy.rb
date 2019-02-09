module Admin
  class ProviderProfilePolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def index?
      privileges.customer_service? || privileges.admin?
    end

    def show?
      index?
    end

    def new?
      privileges.customer_service? || privileges.admin?
    end

    def edit?
      new?
    end

    def update?
      edit?
    end

    def create?
      new?
    end

    def transition?(to_status)
      case to_status.to_s
      when "ask_to_validate"
        privileges.customer_service? || privileges.admin?
      when "validated"
        privileges.customer_service? || privileges.admin?
      when "active"
        privileges.admin?
      end
    end

    def permitted_attributes
      [
        :ruc,
        :email,
        :website,
        :telefono,
        :logotipo,
        :logotipo_cache,
        :remove_logotipo,
        :razon_social,
        :banco_nombre,
        :generate_user,
        :twitter_handle,
        :youtube_handle,
        :facebook_handle,
        :instagram_handle,
        :banco_tipo_cuenta,
        :tipo_contribuyente,
        :banco_numero_cuenta,
        :actividad_economica,
        :representante_legal,
        :provider_category_id,
        :nombre_establecimiento,
        :fecha_inicio_actividad,
        :place_id,
        formas_de_pago: [],
        offices_attributes: offices_attributes
      ]
    end

    private

    def offices_attributes
      Admin::ProviderOfficePolicy.new(user,record).permitted_attributes
    end
  end
end
