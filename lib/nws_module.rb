class String
  def is_number?
    true if Float(self) rescue false
  end
end

module NWSModule

  def self.fetch_table(page)
    page.css('body').search('table')[7].search('tr')
    #page.css('body').css('table')[5].css('tbody')
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
    percents = []
    clouds = []
    chills = []
    winds = []
    means = []
    hours = []
    dates = []
    date = nil
    dews = []
    fetch_table(page).each do |tr,i|
      header = tr.search('td')[0].text
      if header.include? 'Date'
        date = tr.search('td')[1] if !date
        row = :date
      elsif header.include? 'Hour'
        row = :hour
      elsif header.include? 'Temperature'
        row = :mean
      elsif header.include? 'Dewpoint'
        row = :dewpoint
      elsif header.include? 'Sky Cover'
        row = :clouds
      elsif header.include? 'Precipitation'
        row = :percent
      elsif header.include? 'Wind Chill'
        row = :chill
      elsif header.include? 'Surface Wind'
        row = :wind
      end
      tr.search('td').each_with_index do |td,i|
        next if i == 0
        if row == :date
          if td.text.length > 0
            date = td.text
          end
          dates.push date
        elsif row == :hour
          if td.text.is_number?
            hours.push td.text
          end
        elsif row == :mean
          means.push td.text
        elsif row == :dewpoint
          dews.push td.text
        elsif row == :clouds
          clouds.push td.text
        elsif row == :percent
          percents.push td.text
        elsif row == :chill
          chills.push td.text
        elsif row == :wind
          winds.push td.text
        end
      end
      puts hours
    end
    hours.each_with_index do |hour,i|
      time = Time.parse("#{dates[i]} #{hour}:00")
      Point.save_points(run_id,time,'','','',means[i],dews[i],chills[i],clouds[i],percents[i],winds[i])
    end
  end

end
