class CreateStaticSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :static_settings do |t|
      t.integer :max_post_character
      t.integer :max_poll_options
      t.integer :max_poll_option_character
      t.integer :user_fields
      t.integer :min_profile_description_character

      t.timestamps
    end
  end
end
