require 'test_helper'

class PasswordMailerTest < ActionMailer::TestCase

  test 'password reset instructions' do
    user = create_user
    request = ActionDispatch::TestRequest.new
    request.host = 'www.domain.com'

    PasswordMailer.default_url_options[:host] = request.host
    email = PasswordMailer.password_reset_instructions user, request

    assert_equal ['no-reply@domain.com'], email.from
    assert_equal ['joe@example.com'], email.to
    assert_equal "[www.domain.com] Password Reset", email.subject

    reset_url = "http://www.domain.com/passwords/#{user.perishable_token}/edit"
    assert_match reset_url, email.body.encoded
  end

end