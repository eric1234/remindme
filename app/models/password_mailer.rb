class PasswordMailer < ActionMailer::Base
  cattr_accessor :from_user
  self.from_user = 'no-reply'

  def password_reset_instructions(authenticated_record, request)
    @authenticated_record = authenticated_record
    mail :to => authenticated_record.email,
      :from => "#{self.class.from_user}@#{request.domain}",
      :subject => "[#{request.host}] Password Reset"
  end

end
