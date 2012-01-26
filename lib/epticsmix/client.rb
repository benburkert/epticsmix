module EpticsMix
  class Client < Rack::Client::Simple

    EPICMIX_URL = 'https://www.epicmix.com'

    attr_accessor :username, :password, :token

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

    def season_stats
      url = '/vailresorts/sites/epicmix/api/mobile/userstats.ashx'

      response = get(url, headers, :timetype => 'season', :token => 'ABCDEFG1234567890')

      return unless response.status == 200

      if response['Content-Encoding'] == 'gzip'
        body = Zlib::GzipReader.new(StringIO.new(response.body)).read
      else
        body = response.body
      end

      JSON.parse(body)['seasonStats']
    end

    def token_from(response)
      response.headers['Set-Cookie'][%r{ASP.NET_SessionId=([^;]+);}, 1]
    end

    def headers(extra = {})
      extra.merge 'Cookie' => [session_id, website, session_id].join('; '),
                  'Accept-Encoding' => 'gzip',
                  'User-Agent' => 'EpicMix 15880 rv:2.1 (iPhone; iPhone OS 5.0.1; en_US)',
                  'Host' => 'www.epicmix.com'

    end

    def session_id
      "ASP.NET_SessionId=#{token}"
    end

    def website
      "website#sc_wede=1"
    end

  end
end
