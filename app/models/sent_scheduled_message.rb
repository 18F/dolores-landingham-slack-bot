class SentScheduledMessage < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :employee, dependent: :destroy
  belongs_to :scheduled_message, dependent: :destroy

  validates :employee, presence: true, uniqueness: { scope: :scheduled_message }
  validates :message_body, presence: true
  validates :scheduled_message, presence: true
  validates :sent_at, presence: true
  validates :sent_on, presence: true

  delegate :slack_username, to: :employee

  def self.filter(params)
    if params[:slack_username].present? || params[:message_body].present? || params[:sent_on].present?
      @employee = Employee.find_by slack_username: params[:slack_username]

      results = self.all.where("lower(message_body) like ?", "%#{params[:message_body].downcase}%")

      if @employee
        employee_id = @employee.id
        results.where(employee_id: employee_id)
      end

      if !params[:sent_on].blank?
        results.where(sent_on: params[:sent_on])
      end

      results
    else
      self.all
    end
  end
end
