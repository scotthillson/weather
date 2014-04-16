class ForecastController < ApplicationController
	
	def steal_table
		page = 'http://wxweb.meteostar.com/sample/sample.shtml?text=KPDX'
		gfs = Nokogiri::HTML(open(page))
		gfs.css("table")[1].css("td")
	end

	def temperature_chart

		table = steal_table
		@high = Array.new
		@low = Array.new
		@time = Array.new
		marker = 0
		i = 0
		
		table.each do |cell|
			text = cell.text.to_s.gsub("\n","").strip.tr('^A-Za-z0-9','')
			
			#marker = 4 if text == '384'
			#marker = 3 if text == '192'
			marker = 2 if text == '180'
			marker = 1 if text == 'FCSTHour' && marker == 0
			
			if marker == 1 || marker == 2
				if ( i - 1 ) % 19 == 0 && i > 19
					m = text[3..4]
					d = text[5..6]
					h = text[7..8]
					t = Time.new('2014',m,d,h) - 25200
					t = t.strftime("%m/%d/%Y %l%P")
					@time.push(t)
				end
				@high.push(text) if (i - 3) % 19 == 0 && i > 19
				if (i - 4) % 19 == 0
					@low.push(text) if i > 18
					marker = 5 if marker == 2
				end
			end
			if marker == 3 || marker == 4
				row << text + ',' if (i - 6) % 18 == 0
				row << text + ',' if (i - 8) % 18 == 0
				if (i - 9) % 18 == 0
					row << text
					@temps.push(row) if i > 18
					row = ''
					marker = 5 if marker == 4
				end
			end
			i = i + 1 if marker > 0
		end
	end
end