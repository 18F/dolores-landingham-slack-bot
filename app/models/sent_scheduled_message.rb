class SentScheduledMessage < ActiveRecord::Base
  belongs_to :employee
  belongs_to :scheduled_message

  validates :employee, presence: true, uniqueness: { scope: :scheduled_message }
  validates :message_body, presence: true
  validates :scheduled_message, presence: true
  validates :sent_on, presence: true

  delegate :slack_username, to: :employee
end
