module ApplicationHelper
  def provider_profiles_for_select
    ProviderProfile.by_nombre
                   .decorate
                   .map do |provider_profile|
      [ provider_profile.to_s, provider_profile.id ]
    end
  end
end
