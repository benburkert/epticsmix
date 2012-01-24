require 'sinatra/base'
require 'sinatra_auth_github'
require 'rack/client'
require 'active_support'
require 'active_record'
require 'logger'

module EpticsMix
  def self.setup!
    ActiveRecord::Base.establish_connection(database_config)

    ActiveRecord::Base.logger = Logger.new STDOUT
  end

  def self.database_config
    db = URI.parse(ENV['DATABASE_URL'])

    {
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    }
  end
end

require 'epticsmix/app'
require 'epticsmix/client'
require 'epticsmix/user'
