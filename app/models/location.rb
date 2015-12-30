class Location < ActiveRecord::Base
  
  has_many :subscriptions
  has_many :runs
  
  def self.populate_all
    locations = all
    locations.each do |location|
      location.populate if location.url
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
  
  def populate
    Log.create_log('run search beginning','',self.name,'','','')
    page = open_page(self.url)
    if self.model == 'gfs'
      runs = get_runs_for_gfs(page)
    elsif self.model == 'nws'
      runs = [get_runs_for_nws(page)[:time].to_s]
    end
    if !runs
      return false
    end
    runs.each do |run|
      run_id = Run.search_runs(Time.parse(run),self.url,self)
      if run_id
        if self.model == 'gfs'
          MeteostarModule.parse_meteostar(page,run_id)
        elsif self.model == 'nws'
          zone = self.time_zone
          NWSModule.parse_nws(page,run_id,zone)
          if self.url_two
            page = open_page(self.url_two)
            NWSModule.parse_nws(page,run_id,zone)
          end
          if self.url_three
            page = open_page(self.url_three)
            NWSModule.parse_nws(page,run_id,zone)
          end
        end
      end
    end
  end
  
end
