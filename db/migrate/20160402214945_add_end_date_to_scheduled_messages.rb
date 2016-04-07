class AddEndDateToScheduledMessages < ActiveRecord::Migration
  def change
    add_column :scheduled_messages, :end_date, :date
  end
end
