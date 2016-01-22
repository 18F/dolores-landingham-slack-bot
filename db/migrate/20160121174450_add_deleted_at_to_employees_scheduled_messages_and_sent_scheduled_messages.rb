class AddDeletedAtToEmployeesScheduledMessagesAndSentScheduledMessages < ActiveRecord::Migration
  def change
    add_column :employees, :deleted_at, :datetime
    add_column :scheduled_messages, :deleted_at, :datetime
    add_column :sent_scheduled_messages, :deleted_at, :datetime

    add_index :employees, :deleted_at
    add_index :scheduled_messages, :deleted_at
    add_index :sent_scheduled_messages, :deleted_at
  end
end
