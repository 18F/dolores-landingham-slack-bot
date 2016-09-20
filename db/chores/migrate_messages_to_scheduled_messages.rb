require_relative "migration_helper_methods"

class MigrateMessagesToScheduledMessages
  include MigrationHelperMethods

  def perform
    execute("SELECT * FROM onboarding_messages").each do |row|
      migrate_onboarding_message_to_scheduled_message(row)
    end
    execute("SELECT * FROM quarterly_messages").each do |row|
      migrate_quarterly_message_to_scheduled_message(row)
    end
  end

  private

  SCHEDULED_MESSAGE_COLUMNS = [
    "created_at",
    "updated_at",
    "title",
    "body",
    "days_after_start",
    "time_of_day",
    "type",
    "end_date",
    "deleted_at",
  ].freeze

  def migrate_onboarding_message_to_scheduled_message(row)
    # Migrate to new table
    row["type"] = 0
    values = SCHEDULED_MESSAGE_COLUMNS.map do |column|
      sanitize(row[column])
    end
    scheduled_message_id = insert(
      <<-SQL
        INSERT INTO scheduled_messages (#{SCHEDULED_MESSAGE_COLUMNS.join(',')})
        VALUES (#{values.join(',')})
      SQL
    )

    # Update other tables
    migrate_sent_messages(row["id"], "OnboardingMessage", scheduled_message_id)
    migrate_taggings(row["id"], "OnboardingMessage", scheduled_message_id)
  end

  def migrate_quarterly_message_to_scheduled_message(row)
    # Migrate to new table
    row["type"] = 1
    row["time_of_day"] = "2000-01-01 12:00:00"
    values = SCHEDULED_MESSAGE_COLUMNS.map do |column|
      sanitize(row[column])
    end
    quarterly_message_id = insert(
      <<-SQL
        INSERT INTO scheduled_messages (#{SCHEDULED_MESSAGE_COLUMNS.join(',')})
        VALUES (#{values.join(',')})
      SQL
    )

    # Update other tables
    migrate_sent_messages(row["id"], "QuarterlyMessage", quarterly_message_id)
    migrate_taggings(row["id"], "QuarterlyMessage", quarterly_message_id)
  end

  def migrate_sent_messages(old_id, old_type, new_id)
    execute(
      <<-SQL
        UPDATE sent_messages
        SET message_id = #{new_id}, message_type = NULL
        WHERE message_id = #{old_id} AND message_type = '#{old_type}'
      SQL
    )
  end

  def migrate_taggings(old_id, old_type, new_id)
    execute(
      <<-SQL
        UPDATE taggings
        SET taggable_id = #{new_id}, taggable_type = 'ScheduledMessage'
        WHERE taggable_id = #{old_id} AND taggable_type = '#{old_type}'
      SQL
    )
  end
end
