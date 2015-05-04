class LocationsController < ApplicationController

  before_action :set_location, only: :show

  def index
    @locations = Location.all
  end

  def show
    runs_array = []
    @tables = {}
    inches = {}
    clouds = {}
    times = []
    highs = {}
    means = {}
    lows = {}
    dews = {}
    pots = {}
    recent = nil
    runs = Run.where(location_id: @location.id).order('run').reverse.first(8)
    return if runs.length < 1
    recent = runs[0].run_time.to_s
    runs.each do |run|
      r = run.run_time.to_s
      runs_array.push(r)
      points = run.points
      points.each do |p|
        #time = p.time.in_time_zone('Pacific Time (US & Canada)').strftime("%A %-m-%d %l%P")
        time = p.time#.to_s
        key = "#{r}#{time}"
        highs[key] = p.high_temperature_predicted
        inches[key] = p.rain_inches_predicted
        lows[key] = p.low_temperature_predicted
        means[key] = p.mean_temperature_predicted
        clouds[key] = p.cloud_cover
        pots[key] = p.precipitation_potential
        dews[key] = p.dewpoint_predicted
        times.push(time) if r == recent
      end
      join_tables(r,recent,times,highs,lows,inches,means,clouds,pots,dews)
    end
    gon.columns = ['High','Low','Inches','Mean','Clouds','Potential','Dewpoint']
    gon.colors = ['Red','Purple','Black','Orange','Gray','Blue','Purple']
    gon.runs = runs_array
    gon.tables = @tables
    gon.times = times
  end

  def join_tables(run,recent,times,highs,lows,inches,means,clouds,pots,dews)
    array = []
    times.each do |time|
      master_key = "#{recent}#{time}"
      key = "#{run}#{time}"
      high = highs[key] ? highs[key] : highs[master_key]
      low = lows[key] ? lows[key] : lows[master_key]
      inch = inches[key] ? inches[key] : inches[master_key]
      mean = means[key] ? means[key] : means[master_key]
      cloud = clouds[key] ? clouds[key] : clouds[master_key]
      pot = pots[key] ? pots[key] : pots[master_key]
      dew = dews[key] ? dews[key] : dews[master_key]
      text = [time, high.to_i, low.to_i, inch.to_i, mean.to_i, cloud.to_i, pot, dew]
      array.push(text)
    end
    @tables[run] = array
  end

  private

  def set_location
    @location = Location.where('code LIKE ?',params[:id]).first
  end

end
