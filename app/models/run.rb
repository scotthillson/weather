class Run < ActiveRecord::Base
  include MeteostarModule
  include NWSModule
  has_many :points

  def self.store_run(run,location,model)
    r = new
    r.location = location
    r.model = model
    r.run = run
    r.save
    r.id
  end

  def self.most_recent(location)
    Run.where(location: location).order('run').last
  end

  def self.search_runs(run,page,location,model)
    existing_run = Run.find_by run: run, location: location, model: model
    if !existing_run
      Log.create_log('creating run',run,location,'','','')
      run_id = Run.store_run(run,location,model)
      if run_id
        MeteostarModule.parse_meteostar(page,run_id)
      end
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
