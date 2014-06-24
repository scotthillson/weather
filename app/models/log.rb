class Log < ActiveRecord::Base

  def self.create_log(action,run)
    log = Log.new
    log.action = action
    log.run = run
    log.save
    log
  end

end