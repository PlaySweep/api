class BatchSlate
  def fetch_datetime date, time
    arr_of_dates = date.split('/').map(&:to_i)
    year = arr_of_dates.pop
    arr_of_dates.unshift(year)


    arr_of_times = time.split(':').map(&:to_i)
    DateTime.new(arr_of_dates[0], arr_of_dates[1], arr_of_dates[2], arr_of_times[0], arr_of_times[1], 0, Time.zone.formatted_offset)
  end
end