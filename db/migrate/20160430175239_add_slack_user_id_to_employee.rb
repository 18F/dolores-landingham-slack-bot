class AddSlackUserIdToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :slack_user_id, :string
    add_index :employees, :slack_user_id
  end
end
