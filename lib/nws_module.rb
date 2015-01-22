module NWSModule

  def self.fetch_nws_table(page)
    page.css('body').css('table')[5].css('tbody')
  end

  def self.get_nws_runs(page)
    page = page.css('body').css('table')[3].css('tr')[0]
    location = page.css('td')[0].text
    time = page.css('td')[1].text
    time = time.gsub 'Last Update: ', ''
    time = Time.parse(time)
    {time: time, location: location}
  end

  def self.parse_nws(page,run_id)
    puts page
  end
end
