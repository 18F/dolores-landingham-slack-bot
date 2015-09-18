class ScheduledMessagesController < ApplicationController
  def new
    @scheduled_message = ScheduledMessage.new
  end

  def create
    @scheduled_message = ScheduledMessage.new(scheduled_message_params)

    if @scheduled_message.save
      flash[:notice] = "Scheduled message created successfully"
      redirect_to root_path
    else
      flash.now[:error] = "Could not create scheduled message"
      render action: :new
    end
  end

  private

  def scheduled_message_params
    params.require(:scheduled_message).permit(:body, :days_after_start, :title)
  end
end
