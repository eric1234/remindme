class PasswordsController < ApplicationController

  # For logmein integration. If you are not using logmein you need to
  # ensure your authentication system allows access to these actions
  # without being authenticated.
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
    @authenticated_record.password = params[:authenticated_record][:password]
    @authenticated_record.password_confirmation = params[:authenticated_record][:password_confirmation]
    if @authenticated_record.save
      next_url = session[:return_to] || send(Remindme.final_destination)
      flash[:notice] = "Password successfully updated"
      # Go ahead an log the user in in case the redirect is to a restricted page
      klass.session_class.create! @authenticated_record
      session.delete :return_to
      redirect_to next_url
    else
      render :action => :edit
    end
  end

  private

  # Verify token so user can update password.
  def load_authenticated_record_by_token
    @authenticated_record = klass.find_using_perishable_token(params[:id])
    render :action => 'invalid' unless @authenticated_record
  end
  before_action :load_authenticated_record_by_token, :only => [:edit, :update]

  # Dymanically determine the authenticated model based on config.
  def klass
    @klass ||= Remindme.authenticated_model_name.constantize
  end

end
