class Temperature < ActiveRecord::Base

	def self.scrape_map(page)
		gfs = Nokogiri::HTML(open(page))
		gfs.css("map")[0].css("area")
	end

	def self.collect
		page = 'http://www.wrh.noaa.gov/mesowest/mwmap.php?map=portland'
		map = scrape_map(page)
		map.each do |area|
			puts area["onmouseover"]
		end
	end

end