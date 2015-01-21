module MeteostarModule

  def self.fetch_meteostar_table(page)
		page.css('table')[1].css('td')
	end

  def self.fetch_meteostar_runs(page)
	  page.css('table')[1].css('form').css('option')
  end

  def self.get_meteostar_runs(page)
    marker = 0
	  runs = Array.new
    form = fetch_meteostar_runs(page)
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

  def self.parse_meteostar(page,run)
    marker = nil
    times = Array.new
    table = fetch_meteostar_table(page)
    rain = {}
		high = {}
		low = {}
		t = nil
		i = 0
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
