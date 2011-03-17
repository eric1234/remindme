class PasswordsController < ApplicationController
  PUBLIC_ACTIONS = %w(new create edit update)

  def create
    authenticated_record = klass.find_by_email params[:email]
    if authenticated_record
      authenticated_record.reset_perishable_token!
      PasswordMailer.default_url_options[:host] = request.host
      PasswordMailer.default_url_options[:port] = request.port
      PasswordMailer.password_reset_instructions(authenticated_record, request).deliver
    else  
      flash.now[:warning] = 'That e-mail was not found'
      render :action => 'new'
    end
  end

  def update
    @authenticated_record.attributes = params[:authenticated_record]
    if @authenticated_record.save
      next_url = session[:return_to] || send(Remindme.final_destination)
      flash[:notice] = "Password successfully updated"
      klass.session_class.create! @authenticated_record
      session.delete :return_to
      redirect_to next_url
    else  
      render :action => :edit
    end  
  end

  private

  def load_authenticated_record_by_token
    @authenticated_record = klass.find_using_perishable_token(params[:id]) or
      raise ActiveRecord::RecordNotFound, 'token invalid'
  end
  before_filter :load_authenticated_record_by_token, :only => [:edit, :update]

  def klass
    @klass ||= Remindme.authenticated_model_name.constantize
  end

end
