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
    assert_equal "[domain.com] Password Reset", email.subject

    reset_url = "http://www.domain.com/passwords/#{user.perishable_token}/edit"
    assert_match reset_url, email.body.encoded
  end

  def test_alternate_user
    user = create_user
    request = ActionDispatch::TestRequest.new
    request.host = 'www.domain.com'

    PasswordMailer.from_user = 'me'
    PasswordMailer.default_url_options[:host] = request.host
    email = PasswordMailer.password_reset_instructions user, request

    assert_equal ['me@domain.com'], email.from
  ensure
    PasswordMailer.from_user = 'no-reply'
  end

  def test_alternate_domain
    user = create_user

    PasswordMailer.domain = 'another.com'
    PasswordMailer.default_url_options[:host] = 'example.com'
    email = PasswordMailer.password_reset_instructions user, nil

    assert_equal ['no-reply@another.com'], email.from
  ensure
    PasswordMailer.domain = nil
  end

  def test_fully_changed
    user = create_user
    request = ActionDispatch::TestRequest.new
    request.host = 'www.domain.com'

    PasswordMailer.from_user = 'me'
    PasswordMailer.domain = 'another.com'
    PasswordMailer.default_url_options[:host] = request.host
    email = PasswordMailer.password_reset_instructions user, request

    assert_equal ['me@another.com'], email.from
  ensure
    PasswordMailer.from_user = 'no-reply'
    PasswordMailer.domain = nil
  end

end
