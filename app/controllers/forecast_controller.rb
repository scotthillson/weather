class ForecastController < ApplicationController
  before_action :set_location, only: :weather_chart

  def weather_chart
    runs_array = []
    times = []
    @tables = {}
    inches = {}
    high = {}
    mean = {}
    low = {}
    recent = nil
    runs = Run.where(location: @location).order('run').reverse.first(8)
    if runs.count > 0
      recent = runs[0].run
      runs.each do |run|
        r = run.run
        runs_array.push(r)
        points = run.points
        points.each do |p|
          time = p.time.in_time_zone('Pacific Time (US & Canada)').strftime("%A %-m-%d %l%P")
          key = r + time
          high[key] = p.high_temperature_predicted
          inches[key] = p.rain_inches_predicted
          low[key] = p.low_temperature_predicted
          times.push(time) if r == recent
        end
        join_tables(r,recent,times,high,low,inches)
      end
      puts gon.runs
      gon.runs = runs_array
      gon.tables = @tables
      gon.times = times
    end
  end

  def join_tables(run,recent,times,high,low,inches)
    array = []
    times.each do |time|
      master_key = ( recent + time )
      key = ( run + time )
      h = high[key] ? high[key] : high[master_key]
      l = low[key] ? low[key] : low[master_key]
      r = inches[key] ? inches[key] : inches[master_key]
      text = [ time , h.to_i , l.to_i , r.to_i ]
      array.push(text)
    end
    @tables[run] = array
  end

  def set_location
    @location = Location.where('code LIKE ?',params[:location]).code
  end

end
