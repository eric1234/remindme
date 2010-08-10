class PasswordsController < ApplicationController
  PUBLIC_ACTIONS = %w(new create edit update)

  def create
    user = User.find_by_email params[:email]
    if user
      user.reset_perishable_token!
      session[:return_to] = params[:return_to] if params.has_key? :return_to
      PasswordMailer.default_url_options[:host] = request.host
      PasswordMailer.default_url_options[:port] = request.port
      PasswordMailer.deliver_password_reset_instructions user, request
    else  
      flash[:warning] = "No user was found with that email address"
      render :action => 'new'
    end
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      next_url = session[:return_to] || root_url
      flash[:notice] = "Password successfully updated"
      UserSession.create! @user
      session.delete :return_to
      redirect_to next_url
    else  
      render :action => :edit
    end  
  end

  private

  def load_user_by_token
    @user = User.find_using_perishable_token(params[:id]) or
      raise ActiveRecordError::RecordNotFound, 'token invalid'
  end
  before_filter :load_user_by_token, :only => [:edit, :update]

end
