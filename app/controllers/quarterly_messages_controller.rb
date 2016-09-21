class QuarterlyMessagesController < ApplicationController
  before_action :current_user_admin, only: [:new, :create, :edit, :update]

  def new
    @quarterly_message = QuarterlyMessage.new
  end

  def create
    @quarterly_message = QuarterlyMessage.new(quarterly_message_params)

    if @quarterly_message.save
      flash[:notice] = I18n.t(
        "controllers.quarterly_messages_controller.notices.create",
      )
      redirect_to quarterly_messages_path
    else
      flash.now[:error] = I18n.t(
        "controllers.quarterly_messages_controller.errors.create",
      )
      render action: :new
    end
  end

  def index
    @quarterly_messages = QuarterlyMessage.
      filter(params).
      ordered_by_created_at.
      page(params[:page])
  end

  def edit
    @quarterly_message = QuarterlyMessage.find(params[:id])
  end

  def update
    @quarterly_message = QuarterlyMessage.find(params[:id])

    if @quarterly_message.update(quarterly_message_params)
      flash[:notice] = I18n.t(
        "controllers.quarterly_messages_controller.notices.update",
      )
      redirect_to quarterly_messages_path
    else
      flash.now[:error] = I18n.t(
        "controllers.quarterly_messages_controller.errors.update",
      )
      render action: :edit
    end
  end

  def destroy
    quarterly_message = QuarterlyMessage.find(params[:id])
    quarterly_message.destroy

    flash[:notice] = I18n.t(
      "controllers.quarterly_messages_controller.notices.destroy",
      quarterly_message_title: quarterly_message.title,
    )
    redirect_to quarterly_messages_path
  end

  private

  def quarterly_message_params
    params.
      require(:quarterly_message).
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
