require "rails_helper"

feature "View employees" do
  scenario "sees all employee details" do
    login_with_oauth
    visit root_path
    create_employees

    visit employees_path

    expect(page).to have_content(first_employee.slack_username)
    expect(page).to have_content(first_employee.started_on)
    expect(page).to have_content(first_employee.time_zone)
    expect(page).to have_content(second_employee.slack_username)
    expect(page).to have_content(second_employee.started_on)
    expect(page).to have_content(second_employee.time_zone)
  end

  private

  def create_employees
    first_employee
    second_employee
  end

  def first_employee
    @first_employee ||= create(:employee)
  end

  def second_employee
    @second_employee ||= create(:employee)
  end
end
