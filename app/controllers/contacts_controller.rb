class ContactsController < ApplicationController
  respond_to :html, :xml, :json
  make_resourceful do
    actions :new, :show
  end

  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save

        ContactMailer.notify(@contact).deliver
        ContactMailer.contact(@contact).deliver
        format.html { render action: 'show', notice: 'Thanks!  If you put in your email address correctly, you should be getting a confirmation shortly.
                    I usually send a real reply within 24 hours.'}
        #format.json {render json: {contact: @contact, created: true, html: render_to_string(partial: '/contacts/success',
        #                                                               layout: false, locals: {contact: @contact})}}
      else
        format.html { render action: "new" }
        #format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

end
