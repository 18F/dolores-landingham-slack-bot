require "rails_helper"

feature "Delete employees" do
  scenario "from list of employees", :js do
    employee = create(:employee)

    login_with_oauth
    visit employees_path
    page.find(".button-delete").click
    click_accept_on_javascript_popup

    expect(page).to have_content("You deleted #{employee.slack_username}")
  end

  def click_accept_on_javascript_popup
    page.driver.browser.accept_js_confirms
  end
end
