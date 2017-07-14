meeting_rep = MeetingRepository.new

[2016, 2017].each do |year|
  (1..12).each do |month|
    [5, 20].each do |day|
      date = Date.new(year, month, day)
      deadline = Time.new(year, month, day, 22)
      meeting = Meeting.new(date: date, deadline: deadline)
      meeting_rep.create(meeting)
    end
  end
end