# We are trying to avoid accessive configuration but if a bit of config
# will go a long way towards making this gem work for many apps then
# that config will go here.
module Remindme

  # The name of the model as a string. Defaults to User as most apps
  # use that but if your model is not user then simply update in the
  # config.after_initialize hook.
  mattr_accessor :authenticated_model_name
  self.authenticated_model_name = 'User'

  # If your app is in a subdirectory you need to be able to indicate
  # that all routes should be scoped to a directory. Of course leave
  # as nil if your app is in the root directory.
  #
  # Who misses the days of relative_uri_root
  mattr_accessor :route_scope
end

require 'remindme/engine'
