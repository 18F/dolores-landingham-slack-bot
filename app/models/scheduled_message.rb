class ScheduledMessage < ActiveRecord::Base
  validates :body, presence: true
  validates :days_after_start, presence: true
  validates :tag_list, presence: true
  validates :title, presence: true

  acts_as_taggable
end
