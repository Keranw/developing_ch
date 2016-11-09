class EmailMailer < ActionMailer::Base
  default from: 'huntercuriosity@gmail.com'

  def welcome_email(act_link, aim)
    @url  = act_link
    mail(to: aim, subject: 'Welcome to Curiosity Hunter')
  end

  def reset_password_email(act_link, aim)
    @url = act_link
    mail(to: aim, subject: 'Reset your password of Curiosity Hunter')
  end
end
