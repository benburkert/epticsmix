module EpticsMix
  class Client < Rack::Client::Simple

    EPICMIX_URL = 'https://www.epicmix.com'

    attr_accessor :session_id

    def self.login(username, password)
      client = new(nil)
      client.login(username, password)
      client
    end

    def initialize(session_id)
      @session_id = session_id

      super(Rack::Client::Handler::NetHTTP, EPICMIX_URL)
    end

    def login(username, password)
      url = '/vailresorts/sites/epicmix/api/mobile/authenticate.ashx'

      response = post(url, {}, nil, :loginID => username, :password => password)

      @session_id = session_id_from(response)
    end

    def session_id_from(response)
      response.headers['Set-Cookie'][%r{ASP.NET_SessionId=([^;]+);}, 1]
    end
  end
end
