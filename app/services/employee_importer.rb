require "slack-ruby-client"

class EmployeeImporter
  def run(dry_run = false)
    import_results = { created: 0, skipped: 0, dry_run: false }
    slack_user_finder = SlackUserFinder.new("", client)
    total_employees = slack_user_finder.users_list.count

    slack_user_finder.users_list.each_with_index do |user, index|
      if dry_run
        success = dry_import_employee(
          slack_username: user["name"],
          slack_user_id: user["id"],
        )
        import_results[:dry_run] = true
      else
        success = import_employee(
          slack_username: user["name"],
          slack_user_id: user["id"],
        )
      end

      if success
        log_success(index, total_employees, user, dry_run)
        import_results[:created] += 1
      else
        log_failure(index, total_employees, user, dry_run)
        import_results[:skipped] += 1
      end
    end

    import_results
  end

  private

  def client
    @client ||= Slack::Web::Client.new
  end

  def dry_import_employee(slack_username:, slack_user_id:)
    Employee.where(
      slack_username: slack_username,
      slack_user_id: slack_user_id,
    ).empty?
  end

  def import_employee(slack_username:, slack_user_id:)
    employee = Employee.new(
      slack_username: slack_username,
      slack_user_id: slack_user_id,
      started_on: Time.current,
    )

    employee.save
  end

  def log_success(index, total_employees, user, dry_run)
    info = "#{index + 1}/#{total_employees}: Created #{user['name']}"

    if dry_run
      info.concat(" (dry run)")
    end

    Rails.logger.info info.green
  end

  def log_failure(index, total_employees, user, dry_run)
    info = "#{index + 1}/#{total_employees}: Skipped #{user['name']}"

    if dry_run
      info.concat(" (dry run)")
    end

    Rails.logger.info info.yellow
  end
end
