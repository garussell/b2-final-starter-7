class HolidayFacade

  def self.get_next_three_holidays
    next_three_holidays = HolidayService.find_next_three_holidays
    next_three_holidays.map { |holiday_data| Holiday.new(holiday_data) }
  end

  def self.select_holiday(name)
    get_next_three_holidays.find { |holiday| holiday.name == name }
  end
end