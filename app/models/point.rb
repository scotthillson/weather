class Point < ActiveRecord::Base
  belongs_to :run

  def self.save_points(run,time,high,low,inches)
    if !!run && !!time && !!h && !!l && !!r
      point = new
      point.run_id = run
      point.time = time
      point.high_temperature_predicted = high
      point.low_temperature_predicted = low
      point.rain_inches_predicted = inches
      point.save
    else
      Log.create_log('problem with point param','','','','','')
    end
  end
  
  def self.parse_points(run,times,high,low,inches)
    times.each do |time|
      high = high[time].to_i
      low = low[time].to_i
      inches = inches[time].round(2)
      self.save_points(run,time,high,low,inches)
    end
  end
  
end
