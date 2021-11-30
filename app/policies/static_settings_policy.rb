# frozen_string_literal: true

class StaticSettingsPolicy < ApplicationPolicy
  def update?
    admin?
  end

  def show?
    admin?
  end

end
