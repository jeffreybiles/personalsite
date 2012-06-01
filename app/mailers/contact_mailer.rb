class ContactMailer < ActionMailer::Base
  default from: "bilesjeffrey@gmail.com"

  def contact(user)
    @email = user.email
    mail(to: user.email, subject: "Thanks for signing up for Tales of Oakvale")
  end
end
