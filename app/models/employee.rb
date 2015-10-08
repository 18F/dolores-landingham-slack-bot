class Employee < ActiveRecord::Base
  validates :slack_username, presence: true, uniqueness: true, format: { with: /\A[a-z_0-9.]+\z/, message: "Slack usernames can only contain lowercase letters, numbers, underscores, and periods." }
  validates :started_on, presence: true
end
