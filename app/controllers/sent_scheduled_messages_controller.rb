class SentScheduledMessagesController < ApplicationController
  def index
    @sent_scheduled_messages = SentScheduledMessage.order(sent_on: :desc).page(params[:page])
  end
end
