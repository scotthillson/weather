class Run < ActiveRecord::Base
  include MeteostarModule
  include NWSModule
  has_many :points

  def self.store_run(run,location)
    r = new
    r.location = location
    r.location_id = location
    r.run_time = run
    r.save
    r.id
  end

  def self.most_recent(location)
    Run.where(location: location).order('run').last
  end

  def self.search_runs(run,page,location)
    existing_run = Run.find_by run_time: run, location_id: location.id
    if !existing_run
      Log.create_log('creating run',run,location.code,'','','')
      run_id = Run.store_run(run,location.id)
    end
    if run_id
      run_id
    else
      nil
    end
  end

  def self.strip_crap(string)
    string.gsub("\n","").strip.tr('^A-Za-z0-9.','')
  end

  def self.parse_time(text)
    m = text[3..4]
    d = text[5..6]
    h = text[7..8]
    t = Time.new('2014',m,d,h)
  end

end
