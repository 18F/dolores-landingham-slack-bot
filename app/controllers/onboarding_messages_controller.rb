class OnboardingMessagesController < ApplicationController
  before_action :current_user_admin, only: [:new, :create, :edit, :update]

  def new
    @onboarding_message = OnboardingMessage.new
  end

  def create
    @onboarding_message = OnboardingMessage.new(onboarding_message_params)

    if @onboarding_message.save
      flash[:notice] = I18n.t(
        "controllers.onboarding_messages_controller.notices.create",
      )
      redirect_to onboarding_messages_path
    else
      flash.now[:error] = I18n.t(
        "controllers.onboarding_messages_controller.errors.create",
      )
      render action: :new
    end
  end

  def index
    @onboarding_messages = OnboardingMessage.
      filter(params).
      date_time_ordering.
      page(params[:page])
  end

  def edit
    @onboarding_message = OnboardingMessage.find(params[:id])
  end

  def update
    @onboarding_message = OnboardingMessage.find(params[:id])

    if @onboarding_message.update(onboarding_message_params)
      flash[:notice] = I18n.t(
        "controllers.onboarding_messages_controller.notices.update",
      )
      redirect_to onboarding_messages_path
    else
      flash.now[:error] = I18n.t(
        "controllers.onboarding_messages_controller.errors.update",
      )
      render action: :edit
    end
  end

  def destroy
    onboarding_message = OnboardingMessage.find(params[:id])
    onboarding_message.destroy

    flash[:notice] = I18n.t(
      "controllers.onboarding_messages_controller.notices.destroy",
      onboarding_message_title: onboarding_message.title,
    )
    redirect_to onboarding_messages_path
  end

  private

  def onboarding_message_params
    params.
      require(:onboarding_message).
      permit(
        :body,
        :days_after_start,
        :end_date,
        :tag_list,
        :time_of_day,
        :title,
      )
  end
end
