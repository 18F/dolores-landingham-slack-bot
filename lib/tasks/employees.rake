namespace :employees do
  desc "Imports all employees from Slack into the Dolores Landingham bot."
  task import: :environment do
    logger = ActiveSupport::Logger.new("log/employees_import.log")
    start_time = Time.now

    logger.info "Employee import task started at #{start_time}."

    import_statistics = EmployeeImporter.new.import

    end_time = Time.now
    duration = (start_time - end_time) / 1.seconds

    logger.info "Employee import task finished at #{end_time} (#{duration} seconds running time)."
    logger.info "Employees imported: #{import_statistics[:created]}"
    logger.info "Employees skipped: #{import_statistics[:skipped]}"

    logger.close
  end

  namespace :import do
    desc <<-DESC
      Performs a dry run of importing all employees from Slack into the Dolores Landingham bot.
      This task is meant to be run by a user on the command line.
    DESC
    task dry_run: :environment do
      start_time = Time.now

      puts "Employee import dry run task started at #{start_time}."

      import_statistics = EmployeeImporter.new.import(dry_run: true)

      end_time = Time.now
      duration = (start_time - end_time) / 1.seconds

      puts "Employee import dry run task finished at #{end_time} (#{duration} seconds running time)."
      puts "Employees imported: #{import_statistics[:created]} (dry run)".green
      puts "Employees skipped: #{import_statistics[:skipped]} (dry run)".yellow
    end
  end
end
