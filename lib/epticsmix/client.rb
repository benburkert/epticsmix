module EpticsMix
  class Client < Rack::Client::Simple

    EPICMIX_URL = 'https://www.epicmix.com'

    attr_accessor :username, :password, :token

    def self.login(username, password)
      new(nil).login(username, password)
    end

    def initialize(username, password)
      @username, @password = username, password

      super(Rack::Client::Handler::NetHTTP, EPICMIX_URL)

      @token = login
    end

    def login
      url = '/vailresorts/sites/epicmix/api/mobile/authenticate.ashx'

      response = post(url, {}, nil, :loginID => username, :password => password)

      token_from(response) if response.status == 200
    end

    def token_from(response)
      response.headers['Set-Cookie'][%r{ASP.NET_SessionId=([^;]+);}, 1]
    end
  end
end
