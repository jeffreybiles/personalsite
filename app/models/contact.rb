class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name

  after_create :deliver_contact_notification

  def deliver_contact_notification
    ContactMailer.contact(self).deliver
  end
end
