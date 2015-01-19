class Subscription < ActiveRecord::Base
  belongs_to :location
  validates_presence_of :email

  def self.hourly
    subs = Subscription.where(frequency: 'Hourly', rain: true)
    subs.each do |s|
      to = s.email
      location = s.location.icao
      self.compile(location,to)
    end
  end
  
  def self.compile_body(body)
    body + ".#{amount.to_s} inches at #{time.strftime("%l%P %A %-m-%d")} \n"
  end

	def self.compile(location,to)
    puts location
    run = Run.most_recent(location)
    points = run.points.order('time')
    now = DateTime.now
    body = String.new
    points.each do |p|
      time = p.time
      if now < time
        amount = p.rain.to_i
        if log = Log.find_by(action: 'rain email', time: time, email: to, location: location)
          if amount != log.note.to_i
            log.update_email_log(amount)
            body = compile_body(body)
          end
        else
          if p.rain.to_i > 1
            body = compile_body(body)
            Log.create_log('rain email',run,location,time,to,amount)
          end
        end
      end
    end
    if body.length > 0
     	SubscriptionMailer.rain_warning(body,to).deliver
  	else
  		puts 'no warnings to mail'
    end
  end

end
