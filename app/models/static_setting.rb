# == Schema Information
#
# Table name: static_settings
#
#  id                                :bigint(8)        not null, primary key
#  max_post_character                :integer
#  max_poll_options                  :integer
#  max_poll_option_character         :integer
#  user_fields                       :integer
#  min_profile_description_character :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
class StaticSetting < ApplicationRecord
	validates :max_post_character, numericality: { greater_than: 0, less_than_or_equal_to: 5000}, unless: -> { max_post_character.blank? }
	validates :max_poll_options, numericality: { greater_than: 0, less_than_or_equal_to: 10}, unless: -> { max_poll_options.blank? }
	validates :max_poll_option_character, numericality: { greater_than: 0, less_than_or_equal_to: 1000}, unless: -> { max_poll_option_character.blank? }
	validates :user_fields, numericality: { greater_than: 0, less_than_or_equal_to: 10}, unless: -> { user_fields.blank? }
	validates :min_profile_description_character, numericality: { greater_than: 0, less_than_or_equal_to: 1000}, unless: -> { min_profile_description_character.blank? }
end
