class ForecastController < ApplicationController
  before_action :set_location, only: :weather_chart

  def weather_chart
    runs_array = []
    times = [] 
    @tables = {}
    inches = {}
    clouds = {}
    highs = {}
    means = {}
    lows = {}
    pots = {}
    recent = nil
    runs = Run.where(location_id: @location.id).order('run').reverse.first(8)
    if runs.count > 0
      recent = runs[0].run_time.to_s
      runs.each do |run|
        r = run.run_time.to_s
        runs_array.push(r)
        points = run.points
        points.each do |p|
          time = p.time.in_time_zone('Pacific Time (US & Canada)').strftime("%A %-m-%d %l%P")
          key = r + time
          highs[key] = p.high_temperature_predicted
          inches[key] = p.rain_inches_predicted
          lows[key] = p.low_temperature_predicted
          means[key] = p.mean_temperature_predicted
          clouds[key] = p.cloud_cover
          pots[key] = p.precipitation_potential
          times.push(time) if r == recent
        end
        join_tables(r,recent,times,highs,lows,inches,means,clouds,pots)
      end
      gon.runs = runs_array
      gon.tables = @tables
      gon.times = times
    end
  end

  def join_tables(run,recent,times,highs,lows,inches,means,clouds,pots)
    array = []
    times.each do |time|
      master_key = ( recent + time )
      key = ( run + time )
      high = highs[key] ? highs[key] : highs[master_key]
      low = lows[key] ? lows[key] : lows[master_key]
      inch = inches[key] ? inches[key] : inches[master_key]
      mean = means[key] ? means[key] : means[master_key]
      cloud = clouds[key] ? clouds[key] : clouds[master_key]
      pot = pots[key] ? pots[key] : pots[master_key]
      text = [ time , high.to_i , low.to_i , inch.to_i, mean.to_i, cloud.to_i , pot ]
      array.push(text)
    end
    @tables[run] = array
  end

  def set_location
    @location = Location.where('code LIKE ?',params[:location]).first
  end

end
