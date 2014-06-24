class Run < ActiveRecord::Base
  has_many :points

  def self.store_run(run,location,model)
    r = Run.new
    r.location = location
    r.model = model
    r.run = run
    r.save
    r.id
  end

  def self.most_recent
    Run.order('run').last
  end

  def self.warn
    r = most_recent
    points = r.points.order('time')
    now = DateTime.now
    body = ''
    points.each do |p|
      if now < p.time
        if p.rain.to_i > 5
          body = body + '.' + p.rain.to_i.to_s + ' inches at ' + p.time.time.in_time_zone('Pacific Time (US & Canada)').strftime("%A %-m-%d %l%P") + "\n"
        end
      end
    end
    SubscriptionMailer.rain_warning(body).deliver if body.length
  end

  def self.steal_runs
		url = 'http://wxweb.meteostar.com/sample/sample.shtml?'
    location = 'KPDX'
    model = 'GFS'
    runs = get_runs(url + 'text=KPDX')
    Log.create_log('run search beginning','')
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
        if marker > 16
          marker = -1
        end
      end
      if cell.text.to_s == 'Select a Run'
      	#puts cell.text.to_s
        marker = 1
      end
    end
    runs
  end

  def self.search_runs(run,url,location,model)
    existing_run = Run.find_by run: run, location: location, model: model
    if !existing_run
      Log.create_log('creating run',run)
      run_id = Run.store_run(run,location,model)
      if run_id
        page = url + 'run=' + run + '&text=KPDX'
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

  def self.parse_points(run,times,high,low,rain)
    times.each do |time|
      #puts time.strftime("%A %-m-%d %l%P")
      h = high[time].to_i
      l = low[time].to_i
      r = rain[time].round(2)
      Point.save_points(run,time,h,l,r)
    end
  end

  def self.parse_time(text)
    m = text[3..4]
    d = text[5..6]
    h = text[7..8]
    t = Time.new('2014',m,d,h).in_time_zone('Pacific Time (US & Canada)')
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
    parse_points(run,times,high,low,rain)
	end

end