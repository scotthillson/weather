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

  def get_runs_for_gfs(page)
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
    elsif self.model == 'nws'
      runs = get_runs_for_nws(page)
      runs = [runs[:time].to_s]
    end
    runs.each do |run|
      run_id = Run.search_runs(Time.parse(run),self.url,self)
      if run_id
        if self.model == 'gfs'
          MeteostarModule.parse_meteostar(page,run_id)
        elsif self.model == 'nws'
          NWSModule.parse_nws(page,run_id)
        end
      end
    end
    return 'end'
  end

end
