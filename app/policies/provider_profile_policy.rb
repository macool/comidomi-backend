class ProviderProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        user_id: user.id
      )
    end
  end

  def create?
    # if the user doesn't have a provider profile already
    user.provider_profile.nil?
  end

  def update?
    user.provider_profile.present?
  end

  def permitted_attributes
    # non-allowed attributes
    # tipo_contribuyente
    # fecha_inicio_actividad
    [
      :ruc,
      :email,
      :website,
      :telefono,
      :logotipo,
      :razon_social,
      :banco_nombre,
      :twitter_handle,
      :youtube_handle,
      :facebook_handle,
      :instagram_handle,
      :banco_tipo_cuenta,
      :banco_numero_cuenta,
      :actividad_economica,
      :representante_legal,
      :nombre_establecimiento,
      :provider_category_id,
      formas_de_pago: [],
      offices_attributes: offices_attributes
    ]
  end

  private

  def offices_attributes
    ProviderOfficePolicy.new(user,record).permitted_attributes
  end
end
