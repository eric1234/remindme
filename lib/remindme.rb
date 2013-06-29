# We ideally want the application not need to declare the dependency
# on authlogic. It is just implied since remindme only works with
# authlogic. But authlogic assumes ActiveRecord. There are ways to make
# authlogic work without ActiveRecord so we only want to do this
# require if the app is using ActiveRecord
require 'authlogic' if defined? ActiveRecord

# We are trying to avoid accessive configuration but if a bit of config
# will go a long way towards making this gem work for many apps then
# that config will go here.
module Remindme

  # The name of the model as a string. Defaults to User as most apps
  # use that but if your model is not user then specify another class name
  # in an application initializer.
  mattr_accessor :authenticated_model_name
  self.authenticated_model_name = 'User'

  # A named route that the user should be directed to after the entire
  # reset process is done (they requested reset, got e-mail, followed
  # link, updated password, ...what next...). Defaults to root_url.
  mattr_accessor :final_destination
  self.final_destination = :root_url
end

require 'remindme/engine'
