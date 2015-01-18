class Location < ActiveRecord::Base
  has_many :subscriptions

  def self.steal_runs
    locations = all
    locations.each do |location|
      location.steal_runs_for_location
    end
	end

  def steal_runs_for_location
    runs = Run.get_runs(self.url)
    Log.create_log('run search beginning','',self.icao,'','','')
    runs.each do |run|
      Run.search_runs(run,self.url,self.icao,self.model)
    end
  end

end
