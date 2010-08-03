# Some glue to make it easy to include Rails-specific rake tasks in
# your Rails application. Simply put the following at the bottom of
# your Rakefile:
#
#   require 'remindme/rails_tasks'
glob = "#{Gem.searcher.find('remindme').full_gem_path}/lib/tasks/*.rake"
Dir[glob].each {|ext| load ext}