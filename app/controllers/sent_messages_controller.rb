class SentMessagesController < ApplicationController
  def index
    @sent_messages = SentMessage.filter(params).
      order(created_at: :desc).
      page(params[:page])
  end
end
