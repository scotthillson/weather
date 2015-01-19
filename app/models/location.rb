class Location < ActiveRecord::Base
  has_many :subscriptions

  def self.populate
    locations = all
    locations.each do |location|
      location.get_runs_for_location
    end
	end
  
  def get_runs_for_gfs
    Run.get_meteostar_runs(page)
  end

  def get_runs_for_nws
  end

  def get_runs_for_location
    Log.create_log('run search beginning','',self.name,'','','')
    page = open_page(self.url)
    if self.model == 'gfs'
      runs = self.get_runs_for_gfs(page)
    elsif self.model = 'nws'
      runs = self.get_runs_for_nws(page)
    end
    runs.each do |run|
      Run.search_runs(run,self.url,self.icao,self.model)
    end
  end

end
