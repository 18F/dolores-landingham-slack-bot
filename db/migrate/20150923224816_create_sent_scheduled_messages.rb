class CreateSentScheduledMessages < ActiveRecord::Migration
  def change
    create_table :sent_scheduled_messages do |t|
      t.timestamps null: false
      t.belongs_to :employee, null: false
      t.string :error_message, null: false, default: ''
      t.text :message_body, null: false
      t.belongs_to :scheduled_message, null: false
      t.date :sent_on, null: false
    end

    add_index(
      :sent_scheduled_messages,
      [:employee_id, :scheduled_message_id],
      unique: true,
      name: 'by_employee_scheduled_message',
    )
  end
end
