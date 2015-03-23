# Learn more: http://github.com/javan/whenever

set :environment, 'production'

every 2.hours do
  runner "Location.populate_all"
end

every 6.hours do
  runner "Subscription.hourly"
end
