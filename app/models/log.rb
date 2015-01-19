class Log < ActiveRecord::Base

  scope :future, lambda { |location| where( 'created_at > ? and location = locaiton', DateTime.yesterday.end_of_day , location ) }

  def self.create_log(action,run,location,time,email,note)
    log = new
    log.location = location
    log.action = action
    log.email = email
    log.note = note
    log.time = time
    log.run = run
    log.save
    log
  end
  
  def update_email_log(note)
    self.note = note
    self.save
    self
  end

end
