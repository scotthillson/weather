class Location < ActiveRecord::Base
  has_many :subscriptions

  def self.populate
    locations = all
    locations.each do |location|
      location.get_runs_for_location
    end
	end

  def open_page(page)
    Nokogiri::HTML(open(page))
  end

  def get_runs_for_gfs
    MeteostarModule.get_meteostar_runs(page)
  end

  def get_runs_for_nws(page)
    NWSModule.get_nws_runs(page)
  end

  def get_runs_for_location
    Log.create_log('run search beginning','',self.name,'','','')
    page = open_page(self.url)
    if self.model == 'gfs'
      runs = get_runs_for_gfs(page)
    elsif self.model = 'nws'
      runs = get_runs_for_nws(page)
      return runs
    end
    runs.each do |run|
      Run.search_runs(run,self.url,self.code,self.model)
    end
    return 'end'
  end

end
