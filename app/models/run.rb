class Run < ActiveRecord::Base
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
    where(location: location).order('run').last
  end

  def self.steal_runs
    clear_bad_runs
    url = 'http://wxweb.meteostar.com/sample/sample.shtml?'
    model = 'GFS'
    locations = Location.all.pluck(:icao)
    locations.each do |location|
      steal_runs_for_city(location,url,model)
    end
	end
  
  def self.clear_bad_runs
    all.each do |r|
      if r.points.count < 1
        r.destroy
      end
    end
  end
  
  def self.steal_runs_for_city(location,url,model)
    runs = get_runs(url + 'text=' + location)
    Log.create_log('run search beginning','',location,'','','')
    runs.each do |run|
      search_runs(run,url,location,model)
    end
  end

  def self.get_runs(page)
	  runs = Array.new
    marker = 0
    form = scrape_runs(page)
    form.each do |cell|
      if marker > 0
        marker = marker + 1
        runs.push(cell.text.to_s)
        if marker > 30
          marker = -1
        end
      end
      if cell.text.to_s == 'Select a Run'
        marker = 1
      end
    end
    runs
  end

  def self.search_runs(run,url,location,model)
    existing_run = find_by run: run, location: location, model: model
    if !existing_run
      Log.create_log('creating run',run,location,'','','')
      run_id = store_run(run,location,model)
      if run_id
        page = url + 'run=' + run + '&text=' + location
        parse_page(page,run_id)
      end
    end
  end

  def self.scrape_table(page)
		gfs = Nokogiri::HTML(open(page))
		gfs.css("table")[1].css("td")
	end

  def self.scrape_runs(page)
	  gfs = Nokogiri::HTML(open(page))
	  gfs.css("table")[1].css("form").css("option")
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

  def self.parse_page(page,run)
    times = Array.new
    rain = {}
		high = {}
		low = {}
		marker = nil
		t = nil
		i = 0
    table = scrape_table(page)
		table.each do |cell|
			text = strip_crap(cell.text.to_s)
      marker = 1 if text == 'FCSTHour' && !marker
			marker = 2 if text == '180'
			if marker
				if ( i - 1 ) % 19 == 0 && i > 18
          t = parse_time(text)
          times.push(t)
				end
        if i > 18
          if (i - 3) % 19 == 0
            high[t] = text
          end
          if (i - 4) % 19 == 0
            low[t] = text
          end
          if (i - 9) % 19 == 0
            text = text.to_f*100
            rain[t] = text
            break if marker == 2
          end
        end
        i = i + 1
			end
		end
    Point.parse_points(run,times,high,low,rain)
	end

end