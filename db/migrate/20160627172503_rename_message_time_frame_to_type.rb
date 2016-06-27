class RenameMessageTimeFrameToType < ActiveRecord::Migration
  def change
    rename_column :scheduled_messages, :message_time_frame, :type
  end
end
