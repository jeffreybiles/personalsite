class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name

  #after_create :deliver_contact_notification

  def deliver_contact_notification
    ContactMailer.notify(self).deliver
    ContactMailer.contact(self).deliver
  end
end
