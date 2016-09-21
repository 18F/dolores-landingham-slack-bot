class OnboardingMessage < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable

  has_many :sent_messages, as: :message, dependent: :destroy

  validates :body, presence: true
  validates :days_after_start, presence: true
  validates :tag_list, presence: true
  validates :time_of_day, presence: true
  validates :title, presence: true

  def self.active
    where("end_date IS NULL OR end_date > ?", Date.today)
  end

  def self.date_time_ordering
    order(:days_after_start, :time_of_day)
  end

  def self.filter(params)
    if params[:title].present? ||
        params[:body].present? ||
        params[:tag].present?

      results = where("lower(title) like ?", "%#{params[:title].downcase}%").
        where("lower(body) like ?", "%#{params[:body].downcase}%")

      if params[:tag].present?
        tags = params[:tag].split(",").each(&:strip)
        results = results.tagged_with(tags, any: true)
      end
      results
    else
      all
    end
  end
end
