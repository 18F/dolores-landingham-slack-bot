module TimeHelper

  def time_zone_from_offset(offset)
    ActiveSupport::TimeZone.new(offset).name
  end

  def fast_forward_one_hour
    Timecop.freeze(Time.now + 1.hour)
  end

end
