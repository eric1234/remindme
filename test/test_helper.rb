require 'rails/test_help'
require "authlogic/test_case"
require 'capybara/rails'

class ActiveSupport::TestCase < Test::Unit::TestCase
  setup :activate_authlogic

  # Ensure default config is restored before every test
  setup do
    Remindme.authenticated_model_name = 'User'
    Remindme.final_destination = :root_url
  end

  protected

  # A fixture for creating a new user. This user is explicitly NOT logged in
  # despite AuthLogic's attempts to do so.
  def create_user
    attrs = {
      :email => 'joe@example.com',
      :password => 'password',
      :password_confirmation => 'password'
    }
    User.create!(attrs).tap do
      UserSession.find.destroy if UserSession.find
    end
  end
end

DatabaseCleaner.strategy = :truncation
class ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  teardown do
    DatabaseCleaner.clean
  end
end

# The app would normally define this for us.
class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  connection.create_table :users do |t|
    t.string :email, :null => false
    t.string :crypted_password, :password_salt,
      :persistence_token, :perishable_token
  end unless table_exists?

  acts_as_authentic
end
class UserSession < Authlogic::Session::Base
end
