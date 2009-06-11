[Time, Date].map do |datetime|
  datetime::DATE_FORMATS[:main] = lambda { |time| time.strftime("#{time.day.ordinalize} of %B, %Y") }
end
