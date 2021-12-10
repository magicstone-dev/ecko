# frozen_string_literal: true

class StaticSettingsPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def update?
    admin?
  end

  def show?
    admin?
  end
end
