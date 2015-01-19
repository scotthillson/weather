module NWSModule

  def self.fetch_nws_table(page)
    page.css('body').css('table')[5].css('tbody')
  end

  def self.fetch_nws_run(page)
    page = page.css('body').css('table')[3].css('tbody').css('tr')[0]
    location = page.css('td')[0]
    time = page.css('td')[1]
    {time: time, location: location}
  end

  def self.parse_nws(page,run)
    page = open_page(page)
    
  end
end
