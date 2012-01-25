require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper

  test 'reset form' do
    get :new
    assert_response :success
    assert_select "form[action=#{passwords_path}]" do
      assert_select "input[type=email][name=email]"
    end
  end

  test 'request new password - user found' do
    u = create_user
    old_token = u.perishable_token
    assert_emails 1 do
      post :create, :email => 'joe@example.com'
    end
    assert_response :success
    assert_select 'h1', /sent/i
    u.reload
    assert_not_equal old_token, u.perishable_token
  end

  test 'request new password - user not found' do
    assert_no_emails do
      post :create, :email => 'fake@example.com'
    end
    assert_response :success
    assert_select "form[action=#{passwords_path}]" do
      assert_select "input[type=email][name=email][value=fake@example.com]"
    end
  end

  test 'edit password form - valid token' do
    u = create_user
    u.reset_perishable_token!
    get :edit, :id => u.perishable_token
    assert_response :success
    assert_select "form[action=#{password_path(u.perishable_token)}]" do
      assert_select "input[type=password][name='authenticated_record[password]']"
      assert_select "input[type=password][name='authenticated_record[password_confirmation]']"
    end
  end

  test 'edit password form - invalid token' do
    assert_raises ActiveRecord::RecordNotFound do
      get :edit, :id => 'invalid'
    end
  end

  test 'save password - success' do
    u = create_user
    u.reset_perishable_token!

    with_routing do |set|
      set.draw do
        resources :passwords, :except => [:index, :destroy]
        match 'home' => proc {[200, {}, ['Home page']]}
        root :to => proc {[200, {}, ['Root page']]}
      end

      # Establish baseline
      assert u.valid_password?('password')
      assert !u.valid_password?('foobar')

      # Using default final destination
      put :update, :id => u.perishable_token, :authenticated_record => {
        :password => 'foobar', :password_confirmation => 'foobar'
      }
      assert_redirected_to root_url
      u.reload
      assert u.valid_password?('foobar')

      # Allow alternate destination
      Remindme.final_destination = :home_url
      put :update, :id => u.perishable_token, :authenticated_record => {
        :password => 'foobar', :password_confirmation => 'foobar'
      }
      assert_redirected_to home_url
      u.reload

      # Let session determine final destination
      @request.session[:return_to] = new_password_url
      put :update, :id => u.perishable_token, :authenticated_record => {
        :password => 'foobar', :password_confirmation => 'foobar'
      }
      assert_redirected_to new_password_url
      assert_nil @request.session[:return_to]
    end
  end

  test 'save password - failure' do
    u = create_user
    u.reset_perishable_token!

    put :update, :id => u.perishable_token, :authenticated_record => {
      :password => 'a', :password_confirmation => 'b'
    }
    assert_response :success
    assert_select "form[action=#{password_path(u.perishable_token)}]" do
      assert_select "input[type=password][name='authenticated_record[password]']"
      assert_select "input[type=password][name='authenticated_record[password_confirmation]']"
    end
  end

end
