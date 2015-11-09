class DiagnosticsController < ApplicationController
  def index
    @time_diagnostics = {
      application: {
        current_time: Time.current.strftime("%l:%M:%S %p (%Z %z)"),
        time_zone: Rails.application.config.time_zone,
        clockwork_time_zone: Clockwork.manager.config[:tz]
      },
      server: {
        tz_env_var: ENV["TZ"],
        current_time: Time.now.strftime("%l:%M:%S %p (%Z %z)"),
        time_zone: Time.now.zone
      }
    }
  end
end
