class HolidayService

  def self.find_next_three_holidays
    response = connection("PublicHolidays/#{Date.today.year}/US")
    holidays = JSON.parse(response.body, symbolize_names: true)
    
    next_three_holidays = holidays.select do |holiday| 
      holiday[:date] > Date.today.to_s
    end

    next_three_holidays.first(3)
  end

  def self.connection(endpoint_url)
    url = "https://date.nager.at/api/v3/#{endpoint_url}"
    Faraday.get(url)
  end
end