require "rails_helper"

describe EmployeeImporter do
  describe "#import" do
    it "returns a hash with the number of created employees when no employees exist yet" do
      expected_import_results = {
        created: 4,
        skipped: 0,
        dry_run: false
      }

      actual_import_results = EmployeeImporter.new.run

      expect(actual_import_results).to include(expected_import_results)
    end

    it "returns a hash with the number of skipped employees when employees already exist" do
      expected_import_results = {
        created: 0,
        skipped: 4,
        dry_run: false
      }

      EmployeeImporter.new.run
      actual_import_results = EmployeeImporter.new.run

      expect(actual_import_results).to include(expected_import_results)
    end

    it "returns a hash with the dry_run flag set to true when a dry run import is performed" do
      expected_import_results = {
        created: 4,
        skipped: 0,
        dry_run: true
      }

      actual_import_results = EmployeeImporter.new.run(dry_run: true)

      expect(actual_import_results).to include(expected_import_results)
    end
  end
end
