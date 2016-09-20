require_relative "../chores/migrate_scheduled_messages_to_messages"
require_relative "../chores/migrate_messages_to_scheduled_messages"

class SplitScheduledMessagesIntoOnboardingMessagesAndQuarterlyMessages <
    ActiveRecord::Migration[5.0]

  def up
    # Create tables for new models
    create_table :onboarding_messages do |t|
      t.timestamps null: false
      t.string :title, null: false
      t.string :body, null: false
      t.integer :days_after_start, null: false
      t.time :time_of_day, default: "2000-01-01 12:00:00", null: false
      t.date :end_date
      t.datetime :deleted_at
      t.index :deleted_at
    end
    create_table :quarterly_messages do |t|
      t.timestamps null: false
      t.string :title, null: false
      t.string :body, null: false
      t.datetime :deleted_at
      t.index :deleted_at
    end

    # Generalize sent scheduled messages to handle all messages
    rename_table :sent_scheduled_messages, :sent_messages
    rename_column :sent_messages, :scheduled_message_id, :message_id
    add_column :sent_messages, :message_type, :string

    # Update by_employee_scheduled_message index to polymorphic relationship
    remove_index :sent_messages, name: :by_employee_scheduled_message
    add_index(
      :sent_messages,
      [:employee_id, :message_id, :message_type],
      unique: true,
      name: "by_employee_message",
    )

    # Migrate data
    MigrateScheduledMessagesToMessages.new.perform

    # Add contraints after migrating data
    change_column :sent_messages, :message_type, :string, null: false

    # Drop old tables
    drop_table :scheduled_messages
  end

  def down
    # Create dropped tables
    create_table :scheduled_messages do |t|
      t.timestamps null: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :days_after_start
      t.time :time_of_day, default: "2000-01-01 12:00:00", null: false
      t.datetime :deleted_at
      t.date :end_date
      t.integer :type, default: 0
      t.index :deleted_at
    end

    # Release constraints before migrating
    change_column :sent_messages, :message_type, :string, null: true
    remove_index :sent_message, name: :by_employee_message

    # Migrate data
    MigrateMessagesToScheduledMessages.new.perform

    # Change sent_messages to sent_scheduled_messages
    rename_table :sent_messages, :sent_scheduled_messages
    rename_column :sent_scheduled_messages, :message_id, :scheduled_message_id
    remove_column :sent_scheduled_messages, :message_type

    # Re-add index for employees / scheduled_message_id
    add_index(
      :sent_scheduled_messages,
      [:employee_id, :scheduled_message_id],
      unique: true,
      name: "by_employee_scheduled_message",
    )

    # Drop tables
    drop_table :onboarding_messages
    drop_table :quarterly_messages
  end
end
