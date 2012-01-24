$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'epticsmix'

namespace :db do
  task :env do
    raise "Y U NO SET DATABASE_URL" unless ENV['DATABASE_URL']
  end

  task :create => :env do
    config = EpticsMix.database_config

    ActiveRecord::Base.establish_connection config.merge(:database => nil)
    ActiveRecord::Base.connection.create_database config[:database ], :encoding => :unicode

    EpticsMix.setup!
  end

  task :connect => :env do
    EpticsMix.setup!
  end

  task :migrate => :connect do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate 'db/migrate'
  end
end
