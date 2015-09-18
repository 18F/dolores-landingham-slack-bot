class ScheduledMessage < ActiveRecord::Base
  validates :body, presence: true
  validates :days_after_start, presence: true
  validates :title, presence: true
end
