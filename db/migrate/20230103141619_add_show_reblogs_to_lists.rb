class AddShowReblogsToLists < ActiveRecord::Migration[6.1]
  def up
    add_column :lists, :show_reblogs, :boolean
    change_column_default :lists, :show_reblogs, true
  end

  def down
    remove_column :lists, :show_reblogs
  end
end
