class ContactMailer < ActionMailer::Base
  default from: "bilesjeffrey@gmail.com"

  def notify(stuff)
    @email = stuff.email
    @name = stuff.name
    @message = stuff.message
    mail(to: 'bilesjeffrey@gmail.com', subject: 'someone left you feedback')
  end

  def contact(user)
    mail(to: user.email, subject: "Oh good.  The internet still works.")
  end
end
