class ScheduledMessagesController < ApplicationController
  before_action :current_user_admin, only: [:new, :create, :edit, :update]

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

  def index
    @scheduled_messages = ScheduledMessage.
      filter(params).
      date_time_ordering.
      page(params[:page])
  end

  def edit
    @scheduled_message = ScheduledMessage.find(params[:id])
  end

  def update
    @scheduled_message = ScheduledMessage.find(params[:id])

    if @scheduled_message.update(scheduled_message_params)
      flash[:notice] = "Scheduled message updated successfully"
      redirect_to scheduled_messages_path
    else
      flash.now[:error] = "Could not update scheduled message"
      render action: :edit
    end
  end

  def destroy
    scheduled_message = ScheduledMessage.find(params[:id])
    scheduled_message.destroy

    flash[:notice] = "You deleted #{scheduled_message.title}"
    redirect_to scheduled_messages_path
  end

  private

  def scheduled_message_params
    params.
      require(:scheduled_message).
      permit(
        :body,
        :days_after_start,
        :end_date,
        :tag_list,
        :time_of_day,
        :title,
        :type,
      )
  end
end
