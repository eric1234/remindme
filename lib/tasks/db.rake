require 'pathname'

namespace :remindme do
  namespace :db do
    namespace :migrate do

      desc "Will merge plugin migrations into the app migrations"
      task :merge do
        src = Pathname.new(__FILE__).dirname.join('../../db/migrate/').children
        dest = Rails.root.join('db/migrate/')
        dest.mkpath
        FileUtils.cp_r src, dest
      end

    end
  end
end