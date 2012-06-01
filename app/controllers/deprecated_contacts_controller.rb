class ContactsController < ApplicationController
  def new
    @contact = Contact.new()
  end

  def create
    @contact = Contact.new(params[:deprecated_contacts])
    if @contact.save
      respond_to do |format|
        format.html {render action: :new, notice: 'Thanks!  If you put in your email address correctly, you should be getting a confirmation shortly.
                    I usually send a real reply within 24 hours.!' }
        #format.json {render json: {deprecated_contacts: @contact, created: true, html: render_to_string(partial: '/contact/success',
        #                                                                               layout: false, locals: {deprecated_contacts: @contact})}}
      end
    else
      respond_to do |format|
        format.html {render action: :new, notice: 'There were some problems.  Try again?'}
        #format.json {render json: {deprecated_contacts: @contact, created: false, html: render_to_string(partial: 'contact/error',
        #                                                                                layout: false, locals: {deprecated_contacts: @contact})}}
      end
    end
  end

  def edit

  end

  def update
    @contact = Contact.new(params[:deprecated_contacts])
    if @contact.save
      respond_to do |format|
        format.html {render action: :new, notice: 'Thanks!  If you put in your email address correctly, you should be getting a confirmation shortly.
                    I usually send a real reply within 24 hours.!' }
        format.json {render json: {deprecated_contacts: @contact, created: true, html: render_to_string(partial: '/contact/success',
                                                                                             layout: false, locals: {deprecated_contacts: @contact})}}
      end
    else
      respond_to do |format|
        format.html {render action: :new, notice: 'There were some problems.  Try again?'}
        #format.json {render json: {deprecated_contacts: @contact, created: false, html: render_to_string(partial: 'contact/error',
        #                                                                                      layout: false, locals: {deprecated_contacts: @contact})}}
      end
    end
  end

end

