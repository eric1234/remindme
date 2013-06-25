class PasswordMailer < ActionMailer::Base
  # The user this password reminder should appear to be coming from.
  # Default to 'no-reply@websitedomain.com'. The domain part is
  # automatically determined unless the domain class accessor is set.
  cattr_accessor :from_user
  self.from_user = 'no-reply'

  # Automatically set to the domain of the web request if not set
  cattr_accessor :domain

  def password_reset_instructions(authenticated_record, request)
    @authenticated_record = authenticated_record
    domain = self.class.domain || request.domain
    mail :to => authenticated_record.email,
      :from => "#{self.class.from_user}@#{domain}",
      :subject => "[#{domain}] Password Reset"
  end

end
