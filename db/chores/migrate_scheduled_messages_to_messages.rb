require_relative "migration_helper_methods"

class MigrateScheduledMessagesToMessages
  include MigrationHelperMethods

  def perform
    execute("SELECT * FROM scheduled_messages").each do |row|
      if row["type"] == 0
        migrate_scheduled_message_to_onboarding_message(row)
      elsif row["type"] == 1
        migrate_scheduled_message_to_quarterly_message(row)
      end
    end
  end

  private

  ONBOARDING_MESSAGE_COLUMNS = [
    "created_at",
    "updated_at",
    "title",
    "body",
    "days_after_start",
    "time_of_day",
    "end_date",
    "deleted_at",
  ].freeze

  QUARTERLY_MESSAGE_COLUMNS = [
    "created_at",
    "updated_at",
    "title",
    "body",
    "deleted_at",
  ].freeze

  def migrate_scheduled_message_to_onboarding_message(row)
    # Migrate to new table
    values = ONBOARDING_MESSAGE_COLUMNS.map do |column|
      sanitize(row[column])
    end
    onboarding_message_id = insert(
      <<-SQL
        INSERT INTO onboarding_messages (
          #{ONBOARDING_MESSAGE_COLUMNS.join(',')}
        )
        VALUES (#{values.join(',')})
      SQL
    )

    # Update other tables
    migrate_sent_messages(row["id"], onboarding_message_id, "OnboardingMessage")
    migrate_taggings(row["id"], onboarding_message_id, "OnboardingMessage")
  end

  def migrate_scheduled_message_to_quarterly_message(row)
    # Migrate to new table
    values = QUARTERLY_MESSAGE_COLUMNS.map do |column|
      sanitize(row[column])
    end
    quarterly_message_id = insert(
      <<-SQL
        INSERT INTO quarterly_messages (#{QUARTERLY_MESSAGE_COLUMNS.join(',')})
        VALUES (#{values.join(',')})
      SQL
    )

    # Update other tables
    migrate_sent_messages(row["id"], quarterly_message_id, "QuarterlyMessage")
    migrate_taggings(row["id"], quarterly_message_id, "QuarterlyMessage")
  end

  def migrate_sent_messages(old_id, new_id, new_type)
    execute(
      <<-SQL
        UPDATE sent_messages
        SET message_id = #{new_id}, message_type = '#{new_type}'
        WHERE message_id = #{old_id} AND message_type IS NULL
      SQL
    )
  end

  def migrate_taggings(old_id, new_id, new_type)
    execute(
      <<-SQL
        UPDATE taggings
        SET taggable_id = #{new_id}, taggable_type = '#{new_type}'
        WHERE taggable_id = #{old_id} AND taggable_type = 'ScheduledMessage'
      SQL
    )
  end
end
