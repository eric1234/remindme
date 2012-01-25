# Just in case the app doesn't declare it as a direct dependency
require 'authlogic'

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
