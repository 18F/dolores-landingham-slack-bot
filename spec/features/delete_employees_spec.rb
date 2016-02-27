require "rails_helper"

feature "Delete employees" do
  scenario "from list of employees", :js do
    employee = create(:employee)

    login_with_oauth
    visit employees_path
    click_accept_on_javascript_popup do
      page.find(".button-delete").click
    end

    expect(page).to have_content("You deleted #{employee.slack_username}")
  end
end
