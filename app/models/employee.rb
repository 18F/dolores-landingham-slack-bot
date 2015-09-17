class Employee < ActiveRecord::Base
  validates :slack_username, presence: true, uniqueness: true
  validates :started_on, presence: true
end
