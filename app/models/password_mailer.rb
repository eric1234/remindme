class PasswordMailer < ActionMailer::Base

  def password_reset_instructions(user, request)
    subject       "[#{request.host}] Password Reset"  
    from          "no-reply@#{request.host}"
    recipients    user.email
    body          :user => user
  end

end