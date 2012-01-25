require 'test_helper'

class StoriesTest < ActionDispatch::IntegrationTest

  test 'user cannot remember password' do
    Remindme.final_destination = :new_password_url
    u = create_user
    assert !u.valid_password?('foobar')

    visit '/passwords/new'
    fill_in 'E-mail', :with => 'joe@example.com'
    click_button 'Reset Password'
    assert page.has_content? 'Instructions Sent'

    message = ActionMailer::Base.deliveries.last
    link = URI::parse(message.body.encoded.scan(/http.*/).first.chop).path

    visit link
    fill_in 'Password', :with => 'foobar'
    fill_in 'Password confirmation', :with => 'foobar'
    click_button 'Update'

    assert page.has_content? 'Password Reset'

    u.reload
    assert u.valid_password?('foobar')
  end

end