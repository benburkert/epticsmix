module EpticsMix
  class Client < Rack::Client::Simple

    EPICMIX_URL = 'https://www.epicmix.com'

    attr_accessor :token

    def self.login(username, password)
      new(nil).login(username, password)
    end

    def initialize(token)
      @token = token

      super(Rack::Client::Handler::NetHTTP, EPICMIX_URL)
    end

    def login(username, password)
      url = '/vailresorts/sites/epicmix/api/mobile/authenticate.ashx'

      response = post(url, {}, nil, :loginID => username, :password => password)

      token_from(response)
    end

    def token_from(response)
      response.headers['Set-Cookie'][%r{ASP.NET_SessionId=([^;]+);}, 1]
    end
  end
end
