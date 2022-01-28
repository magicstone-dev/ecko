class AddContentTypeToStatuses < ActiveRecord::Migration[6.1]
  def change
    add_column :statuses, :content_type, :string
  end
end
