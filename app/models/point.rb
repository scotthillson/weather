class Point < ActiveRecord::Base
  belongs_to :run

  def self.save_points(run,time,h,l,r)
    if !!run && !!time && !!h && !!l && !!r
      point = Point.new
      point.run_id = run
      point.time = time
      point.high = h
      point.low = l
      point.rain = r
      point.save
    else
      Log.create_log('problem with point param','','','','','')
    end
  end
  
  def self.parse_points(run,times,high,low,rain)
    times.each do |time|
      h = high[time].to_i
      l = low[time].to_i
      r = rain[time].round(2)
      self.save_points(run,time,h,l,r)
    end
  end
  
end