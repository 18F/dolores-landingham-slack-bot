class RemoveSentMessageEmployeeUniquenessConstraint < ActiveRecord::Migration[5.0]
  def up
    remove_index(:sent_messages, name: "by_employee_message")
  end

  def down
    add_index(
      :sent_messages,
      [:employee_id, :message_id, :message_type],
      unique: true,
      name: "by_employee_message",
    )
  end
end
