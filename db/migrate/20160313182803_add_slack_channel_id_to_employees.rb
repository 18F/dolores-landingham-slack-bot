class AddSlackChannelIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :slack_channel_id, :string
  end
end
