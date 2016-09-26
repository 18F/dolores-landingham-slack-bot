require "rails_helper"

load "db/migrate/20160920181736_split_scheduled_messages_into_onboarding_messages_and_quarterly_messages.rb"
load "db/chores/migration_helper_methods.rb"

describe SplitScheduledMessagesIntoOnboardingMessagesAndQuarterlyMessages do
  include MigrationHelperMethods

  CURRENT_MIGRATION_VERSION = 20160920181736
  PREVIOUS_MIGRATION_VERSION = 20160919185207

  before(:all) do
    ActiveRecord::Migration.verbose = false
  end

  after(:each) do
    migrate_to_version(nil)
  end

  def migrate_to_version(version)
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(
      ActiveRecord::Tasks::DatabaseTasks.migrations_paths,
      version,
    )
    ActiveRecord::Base.clear_cache!
  end

  describe "#up" do
    before(:each) do
      migrate_to_version(PREVIOUS_MIGRATION_VERSION)
    end

    it "should migrate data from scheduled_messages to onboarding_messages" do
      insert_scheduled_message(:onboarding_message)
      old_row = execute("SELECT * FROM scheduled_messages").first

      migrate_to_version(CURRENT_MIGRATION_VERSION)

      all_rows = execute("SELECT * FROM onboarding_messages")
      new_row = all_rows.first

      expect(all_rows.count).to eq(1)
      expect(new_row["created_at"]).to eq(old_row["created_at"])
      expect(new_row["updated_at"]).to eq(old_row["updated_at"])
      expect(new_row["title"]).to eq(old_row["title"])
      expect(new_row["body"]).to eq(old_row["body"])
      expect(new_row["days_after_start"]).to eq(old_row["days_after_start"])
      expect(new_row["time_of_day"]).to eq(old_row["time_of_day"])
      expect(new_row["end_date"]).to eq(old_row["end_date"])
      expect(new_row["type"]).to be_nil
    end

    it "should migrate data from scheduled_messages to quarterly_messages" do
      insert_scheduled_message(:quarterly_message)
      old_row = execute("SELECT * FROM scheduled_messages").first

      migrate_to_version(CURRENT_MIGRATION_VERSION)

      all_rows = execute("SELECT * FROM quarterly_messages")
      new_row = all_rows.first

      expect(all_rows.count).to eq(1)
      expect(new_row["created_at"]).to eq(old_row["created_at"])
      expect(new_row["updated_at"]).to eq(old_row["updated_at"])
      expect(new_row["title"]).to eq(old_row["title"])
      expect(new_row["body"]).to eq(old_row["body"])
      expect(new_row["days_after_start"]).to be_nil
      expect(new_row["time_of_day"]).to be_nil
      expect(new_row["end_date"]).to be_nil
      expect(new_row["type"]).to be_nil
    end

    it "should update taggable relationship on taggings from ScheduledMessage to OnboardingMessage" do
      old_id = insert_scheduled_message(:onboarding_message)

      insert_tagging(old_id, "ScheduledMessage")
      migrate_to_version(CURRENT_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM onboarding_messages").first["id"]

      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'ScheduledMessage'").count
      ).to eq 0
      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'OnboardingMessage' AND taggable_id = #{new_id}").count
      ).to eq 1
    end

    it "should update taggable relationship on taggings from ScheduledMessage to QuarterlyMessage" do
      old_id = insert_scheduled_message(:quarterly_message)

      insert_tagging(old_id, "ScheduledMessage")
      migrate_to_version(CURRENT_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM quarterly_messages").first["id"]

      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'ScheduledMessage'").count
      ).to eq 0
      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'QuarterlyMessage' AND taggable_id = #{new_id}").count
      ).to eq 1
    end

    it "should change sent_scheduled_messages.scheduled_message to sent_message.message for onboarding messages" do
      old_id = insert_scheduled_message(:onboarding_message)

      insert_sent_scheduled_message(old_id)
      migrate_to_version(CURRENT_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM onboarding_messages").first["id"]

      expect(
        execute("SELECT * FROM sent_messages WHERE message_type = 'OnboardingMessage' AND message_id = #{new_id}").count
      ).to eq 1
    end

    it "should change sent_scheduled_messages.scheduled_message to sent_message.message for quarterly messages" do
      old_id = insert_scheduled_message(:quarterly_message)

      insert_sent_scheduled_message(old_id)
      migrate_to_version(CURRENT_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM quarterly_messages").first["id"]

      expect(
        execute("SELECT * FROM sent_messages WHERE message_type = 'QuarterlyMessage' AND message_id = #{new_id}").count
      ).to eq 1
    end
  end

  describe "#down" do
    before(:each) do
      migrate_to_version(CURRENT_MIGRATION_VERSION)
    end

    it "should migrate data from onboarding_messages to scheduled_messages" do
      insert_onboarding_message
      old_row = execute("SELECT * FROM onboarding_messages").first

      migrate_to_version(PREVIOUS_MIGRATION_VERSION)

      all_rows = execute("SELECT * FROM scheduled_messages")
      new_row = all_rows.first

      expect(all_rows.count).to eq(1)
      expect(new_row["created_at"]).to eq(old_row["created_at"])
      expect(new_row["updated_at"]).to eq(old_row["updated_at"])
      expect(new_row["title"]).to eq(old_row["title"])
      expect(new_row["body"]).to eq(old_row["body"])
      expect(new_row["days_after_start"]).to eq(old_row["days_after_start"])
      expect(new_row["time_of_day"]).to eq(old_row["time_of_day"])
      expect(new_row["end_date"]).to eq(old_row["end_date"])
      expect(new_row["type"]).to eq(0)
    end

    it "should migrate data from quarterly_messages to scheduled_messages" do
      insert_quarterly_message
      old_row = execute("SELECT * FROM quarterly_messages").first

      migrate_to_version(PREVIOUS_MIGRATION_VERSION)

      all_rows = execute("SELECT * FROM scheduled_messages")
      new_row = all_rows.first

      expect(all_rows.count).to eq(1)
      expect(new_row["created_at"]).to eq(old_row["created_at"])
      expect(new_row["updated_at"]).to eq(old_row["updated_at"])
      expect(new_row["title"]).to eq(old_row["title"])
      expect(new_row["body"]).to eq(old_row["body"])
      expect(new_row["type"]).to eq(1)
    end

    it "should update taggable relationship on taggings from OnboardingMessage to ScheduledMessage" do
      old_id = insert_onboarding_message

      insert_tagging(old_id, "OnboardingMessage")
      migrate_to_version(PREVIOUS_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM scheduled_messages").first["id"]

      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'OnboardingMessage'").count
      ).to eq 0
      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'ScheduledMessage' AND taggable_id = #{new_id}").count
      ).to eq 1
    end

    it "should update taggable relationship on taggings from QuarterlyMessage to ScheduledMessage" do
      old_id = insert_quarterly_message

      insert_tagging(old_id, "QuarterlyMessage")
      migrate_to_version(PREVIOUS_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM scheduled_messages").first["id"]

      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'QuarterlyMessage'").count
      ).to eq 0
      expect(
        execute("SELECT * FROM taggings WHERE taggable_type = 'ScheduledMessage' AND taggable_id = #{new_id}").count
      ).to eq 1
    end

    it "should change sent_messages.message to sent_scheduled_messages.scheduled_message for onboarding messages" do
      old_id = insert_onboarding_message

      insert_sent_message(old_id, "OnboardingMessage")
      migrate_to_version(PREVIOUS_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM scheduled_messages").first["id"]

      expect(
        execute("SELECT * FROM sent_scheduled_messages WHERE scheduled_message_id = #{new_id}").count
      ).to eq 1
    end

    it "should change sent_messages.message to sent_scheduled_messages.scheduled_message for quarterly messages" do
      old_id = insert_quarterly_message

      insert_sent_message(old_id, "QuarterlyMessage")
      migrate_to_version(PREVIOUS_MIGRATION_VERSION)

      new_id = execute("SELECT * FROM scheduled_messages").first["id"]

      expect(
        execute("SELECT * FROM sent_scheduled_messages WHERE scheduled_message_id = #{new_id}").count
      ).to eq 1
    end
  end

  def insert_scheduled_message(type)
    type_enum = { onboarding_message: 0, quarterly_message: 1 }[type]
    insert(
      <<-SQL
        INSERT INTO scheduled_messages (
          created_at,
          updated_at,
          title,
          body,
          days_after_start,
          time_of_day,
          type,
          end_date
        )
        VALUES (
          '2016-09-26 12:00:00',
          '2016-09-26 13:00:00',
          'Onboarding',
          'Message body',
          1,
          '12:00:00',
          #{type_enum},
          '2017-09-26 12:00:00'
        )
      SQL
    )
  end

  def insert_onboarding_message
    insert(
      <<-SQL
        INSERT INTO onboarding_messages (
          created_at,
          updated_at,
          title,
          body,
          days_after_start,
          time_of_day,
          end_date
        ) VALUES (
          '2016-09-26 12:00:00',
          '2016-09-26 13:00:00',
          'Onboarding',
          'Message body',
          1,
          '12:00:00',
          '2017-09-26 12:00:00'
        )
      SQL
    )
  end

  def insert_quarterly_message
    insert(
      <<-SQL
        INSERT INTO quarterly_messages (
          created_at,
          updated_at,
          title,
          body
        ) VALUES (
          '2016-09-26 12:00:00',
          '2016-09-26 13:00:00',
          'Onboarding',
          'Message body'
        )
      SQL
    )
  end

  def insert_tagging(taggable_id, taggable_type)
    insert(
      <<-SQL
        INSERT INTO taggings (
          tag_id,
          taggable_id,
          taggable_type,
          context,
          created_at
        )
        VALUES (
          1,
          #{taggable_id},
          '#{taggable_type}',
          'tags',
          '2016-09-26 12:00:00'
        )
      SQL
    )
  end

  def insert_sent_scheduled_message(scheduled_message_id)
    insert(
      <<-SQL
        INSERT INTO sent_scheduled_messages (
          created_at,
          updated_at,
          employee_id,
          message_body,
          scheduled_message_id,
          sent_on,
          sent_at
        ) VALUES (
          '2016-09-26 12:00:00',
          '2016-09-26 13:00:00',
          1,
          'Message body',
          #{scheduled_message_id},
          '2016-09-26',
          '12:00:00'
        )
      SQL
    )
  end

  def insert_sent_message(message_id, message_type)
    insert(
      <<-SQL
        INSERT INTO sent_messages (
          created_at,
          updated_at,
          employee_id,
          message_body,
          message_id,
          message_type,
          sent_on,
          sent_at
        ) VALUES (
          '2016-09-26 12:00:00',
          '2016-09-26 13:00:00',
          1,
          'Message body',
          #{message_id},
          '#{message_type}',
          '2016-09-26',
          '12:00:00'
        )
      SQL
    )
  end
end
