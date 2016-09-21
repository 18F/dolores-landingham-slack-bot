class QuarterlyMessage < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable

  has_many :sent_messages, as: :message, dependent: :destroy

  validates :body, presence: true
  validates :tag_list, presence: true
  validates :title, presence: true

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
