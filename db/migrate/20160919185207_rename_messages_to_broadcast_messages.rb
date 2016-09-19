class RenameMessagesToBroadcastMessages < ActiveRecord::Migration[5.0]
  def change
    rename_table :messages, :broadcast_messages
  end
end
