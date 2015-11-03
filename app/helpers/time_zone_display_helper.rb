module TimeZoneDisplayHelper
  def display_local_time_zone(sent_scheduled_message)
    zone = ActiveSupport::TimeZone.new(sent_scheduled_message.employee.time_zone)
    tz_offset = zone.now.strftime("%:z")
    sent_local_time = sent_scheduled_message.sent_at.localtime(tz_offset)
    sent_local_time_zone = sent_scheduled_message.sent_at.in_time_zone(sent_scheduled_message.employee.time_zone).zone
    sent_local_time.strftime("%l:%M %p (#{sent_local_time_zone})").strip
  end
end
