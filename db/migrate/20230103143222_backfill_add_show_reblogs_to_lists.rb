class BackfillAddShowReblogsToLists < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    List.unscoped.in_batches do |relation|
      relation.update_all show_reblogs: true
      sleep(0.01)
    end
  end
end
