# frozen_string_literal: true

class Settings::StaticSettingsController < Settings::BaseController

  def show
    @static_setting = StaticSetting.last || StaticSetting.new
    authorize :static_settings, :show?
  end

  def update
    authorize :static_settings, :update?
    if update_or_create
      redirect_to settings_static_settings_path, notice: I18n.t('generic.changes_saved_msg')
    else
      render :show
    end
  end

  private

  def update_or_create
    @static_setting = StaticSetting.last || StaticSetting.new(resource_params)
    resource_params[:id].empty? ? @static_setting.save : @static_setting.update(resource_params)
    rescue Mastodon::DimensionsValidationError
      false
  end

  def resource_params
    params.require(:static_setting).permit(:id, :max_post_character, :max_poll_options, :max_poll_option_character, :user_fields, :min_profile_description_character)
  end

end