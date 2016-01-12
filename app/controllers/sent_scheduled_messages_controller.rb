class SentScheduledMessagesController < ApplicationController
  def index
    @sent_scheduled_messages = SentScheduledMessage.filter(params).order(sent_on: :desc)
  end
end
