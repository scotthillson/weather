class Point < ActiveRecord::Base
  belongs_to :run

  def self.save_points(run,time,high,low,inches,mean,dewpoint,chill,clouds,precip,wind)
    if !!run && !!time
      point = new
      point.time = time
      point.run_id = run
      point.rain_inches_predicted = inches if inches
      point.high_temperature_predicted = high if high
      point.dewpoint_predicted = dewpoint if dewpoint
      point.precipitation_potential = precip if precip
      point.mean_temperature_predicted = mean if mean
      point.low_temperature_predicted = low if low
      point.wind_chill_predicted = chill if chill
      point.surface_wind_predicted = wind if wind
      point.cloud_cover = clouds if clouds
      point.save
    end
  end

  def self.parse_points(run,times,highs,lows,inches)
    times.each do |time|
      high = highs[time].to_i
      low = lows[time].to_i
      inch = inches[time].round(2)
      save_points(run,time,high,low,inch,'','','','','','')
    end
  end

  def self.cleanup
    Point.all.each do |point|
      if point.time.zone == "PDT"
        point.time = point.time + 25200 # 7 hours
        point.save
      elsif point.time.zone == "PST"
        point.time = point.time + 28800 # 8 hours
        point.save
      end
    end
  end

end
