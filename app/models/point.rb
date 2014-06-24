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
      Log.create_log('problem with point param','')
    end
  end
end