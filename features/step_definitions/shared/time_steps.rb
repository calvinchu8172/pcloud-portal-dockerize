Given /^"([^"]*)" days later$/ do |days|
  Timecop.travel(Time.now + days.to_i.days)
end

Given /^"([^"]*)" minutes later$/ do |minutes|
  Timecop.travel(Time.now + minutes.to_i.minutes)
end

Given /^"([^"]*)" minutes ago$/ do |minutes|
  Timecop.travel(Time.now - minutes.to_i.minutes)
end

Given /^Time now is "([^"]*)"$/ do |time|
  Timecop.freeze(time.to_datetime)
end

Given /^Time is correct$/ do
  Timecop.return
end