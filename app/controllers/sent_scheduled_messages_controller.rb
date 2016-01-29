class SentScheduledMessagesController < ApplicationController
  def index
    @sent_scheduled_messages = SentScheduledMessage.filter(params).order(created_at: :desc).page(params[:page])
  end
end
