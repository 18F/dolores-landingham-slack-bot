require "rails_helper"

feature "View quarterly messages" do
  scenario "sees all message details" do
    login_with_oauth
    visit root_path
    create_quarterly_messages

    visit quarterly_messages_path

    expect(page).to have_content(first_quarterly_message.title)
    expect(page).to have_content(first_quarterly_message.body)
    expect(page).to have_content(second_quarterly_message.title)
    expect(page).to have_content(second_quarterly_message.body)
  end

  scenario "sees pagination controls" do
    allow(Kaminari.config).to receive(:default_per_page).and_return(1)

    login_with_oauth
    visit root_path
    create_quarterly_messages

    visit quarterly_messages_path

    expect(page).to have_content(first_quarterly_message.title)
    expect(page).to have_content(first_quarterly_message.body)

    expect(page).not_to have_content(second_quarterly_message.title)

    expect(page).to have_content("Next")
    expect(page).to have_content("Last")

    click_on "Last"

    expect(page).not_to have_content(first_quarterly_message.title)

    expect(page).to have_content(second_quarterly_message.title)
    expect(page).to have_content(second_quarterly_message.body)

    expect(page).to have_content("Prev")
    expect(page).to have_content("First")
  end

  private

  def create_quarterly_messages
    first_quarterly_message
    second_quarterly_message
  end

  def first_quarterly_message
    @first_quarterly_message ||= create(:quarterly_message,
                                        created_at: Time.now)
  end

  def second_quarterly_message
    @second_quarterly_message ||= create(:quarterly_message,
                                         title: 'Quarterly message 2',
                                         created_at: 1.day.ago)
  end
end
