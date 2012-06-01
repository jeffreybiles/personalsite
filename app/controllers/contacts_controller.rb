class ContactsController < ApplicationController
  respond_to :html, :xml, :json
  make_resourceful do
    actions :index, :new, :edit, :delete, :show
  end

  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { render action: 'new', notice: 'Thanks!  If you put in your email address correctly, you should be getting a confirmation shortly.
                    I usually send a real reply within 24 hours.'}
        format.json {render json: {contact: @contact, created: true, html: render_to_string(partial: '/contacts/success',
                                                                       layout: false, locals: {contact: @contact})}}
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json {render json: {contact: @contact, created: true, html: render_to_string(partial: '/contacts/success',
                                                                                            layout: false, locals: {contact: @contact})}}
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

end
