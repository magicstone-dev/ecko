# frozen_string_literal: true

class Settings::StaticSettingsController < Settings::BaseController
  before_action :set_settings

  def index
    authorize :static_settings, :index?
  end

  def show
    authorize :static_settings, :show?
  end

  def update
    authorize :static_settings, :update?
    if updated
      redirect_to settings_static_settings_path, notice: I18n.t('generic.changes_saved_msg')
    else
      render :show
    end
  end

  private

  def updated
    @static_setting.update(resource_params)
    rescue Mastodon::DimensionsValidationError
      false
  end

  def resource_params
    params.require(:static_setting).permit(:id, :max_post_character, :max_poll_options, :max_poll_option_character, :user_fields, :min_profile_description_character)
  end

  def set_settings
    @static_setting = StaticSetting.registry
  end
end
