class HolidayFacade

  def self.get_next_three_holidays
    next_three_holidays = HolidayService.find_next_three_holidays
    next_three_holidays.map { |holiday_data| Holiday.new(holiday_data) }
  end
end