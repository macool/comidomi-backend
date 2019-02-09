class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.find_by(id: user.id)
    end
  end

  def show?
    true
  end

  def update?
    true
  end

  def agree_tos?
    true
  end

  def permitted_attributes
    [
      :name,
      :nickname,
      :image,
      :email,
      :ciudad,
      :fecha_nacimiento,
      :custom_image,
      :current_place_id
    ]
  end

  def permitted_attributes_with_password
    # programatically permit the following so
    # we don't mistakenly override
    permitted_attributes + [
      :password
    ]
  end
end
