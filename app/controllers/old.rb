class ForecastController < ApplicationController

  def weather_chart
		@url = 'http://wxweb.meteostar.com/sample/sample.shtml?run='
		@times = Array.new
    @runs = Array.new
    @tables = {}
    @rain = {}
		@high = {}
		@low = {}
    get_runs
    @master = @runs[0]
    gon.runs = @runs
    @runs.each do |run|
      page = @url + run + '&text=KPDX'
      generate_chart(page,run)
    end
    gon.tables = @tables
	end

	def steal_table(page)
		gfs = Nokogiri::HTML(open(page))
		gfs.css("table")[1].css("td")
	end

  def steal_runs(page)
	  gfs = Nokogiri::HTML(open(page))
	  gfs.css("table")[1].css("form").css("option")
  end

  def strip_crap(string)
    string.gsub("\n","").strip.tr('^A-Za-z0-9.','')
  end

  def print_tables(run)
    array = Array.new
    @times.each do |time|
      master = @master+time
      key = run+time
      high = @high[key] ? @high[key] : @high[master]
      low = @low[key] ? @low[key] : @low[master]
      rain = @rain[key] ? @rain[key] : @rain[master]
      text = [ time , high.to_i , low.to_i , rain.round(2) ]
      array.push(text)
    end
    @tables[run] = array
  end

  def get_runs
	  @runs = Array.new
    marker = 0
    form = steal_runs('http://wxweb.meteostar.com/sample/sample.shtml?text=KPDX')
    form.each do |cell|
      if marker > 0
        marker = marker + 1
        @runs.push(cell.text.to_s)
        if marker > 6
          marker = -1
        end
      end
      if cell.text.to_s == 'Select a Run'
      	puts cell.text.to_s
        marker = 1
      end
    end
  end

	def generate_chart(page,run)
		marker = 0
		t = nil
		i = 0
    @table = steal_table(page)
		@table.each do |cell|
			text = strip_crap(cell.text.to_s)
			marker = 1 if text == 'FCSTHour' && marker == 0
			marker = 2 if text == '180'
			if marker == 1 || marker == 2
				if ( i - 1 ) % 19 == 0 && i > 18
					m = text[3..4]
					d = text[5..6]
					h = text[7..8]
					t = Time.new('2014',m,d,h) - 25200
          t = t.strftime("%A %m-%d %l%P")
          @times.push(t) if run == @master
					@key = [run,t].join()
				end
				@high[@key] = text if (i - 3) % 19 == 0 && i > 18
				@low[@key] = text if (i - 4) % 19 == 0 && i > 18
				if (i - 9) % 19 == 0 && i > 18
					text = text.to_f*100
					@rain[@key] = text
					marker = 5 if marker == 2
				end
			end
			i = i + 1 if marker > 0
		end
    print_tables(run)
	end

end