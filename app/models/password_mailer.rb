class PasswordMailer < ActionMailer::Base

  def password_reset_instructions(authenticated_record, request)
    @authenticated_record = authenticated_record
    mail :to => authenticated_record.email,
      :from => "no-reply@#{request.domain}",
      :subject => "[#{request.host}] Password Reset"
  end

end
