class ContactMailer < ActionMailer::Base
  default from: "bilesjeffrey@gmail.com"

  def notify(stuff)
    mail(to: 'bilesjeffrey@gmail.com', subject: 'someone left you feedback')
  end

  def contact(user)
    mail(to: user.email, subject: "Thanks for leaving me feedback")
  end
end
