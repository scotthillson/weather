class SubscriptionMailer < ActionMailer::Base
  default from: 'scott.hillson@gmail.com'

  def rain_warning(body)
    to = 'scott.hillson@gmail.com'
    subject = 'rain warning'
    mail(to: to, subject: subject, body: body)
  end

  def low_warning(body)
    to = 'scott.hillson@gmail.com'
    subject = 'low temperature warning'
    mail(to: to, subject: subject, body: body)
  end

  def high_warning(body)
    to = 'scott.hillson@gmail.com'
    subject = 'high temperature warning'
    mail(to: to, subject: subject, body: body)
  end

end