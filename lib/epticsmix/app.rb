module EpticsMix
  class App < Sinatra::Base
    enable :sessions

    set :github_options, {
      :secret    => ENV['GH_CLIENT_SECRET'],
      :client_id => ENV['GH_CLIENT_ID'],
    }

    register Sinatra::Auth::Github

    before do
      authenticate!
    end

    get '/' do
      <<-HTML
  <html>
    <body>
      <form action='/login' method='post'>
        <p>epicmix.com email: <input type='text' name='username' /></p>
        <p>epicmix.com password: <input type='password' name='password' /></p>
        <p><input type="submit" value="submit" />
      </form>
    </body>
  </html>
      HTML
    end

    post '/login' do
      token = Client.login(params[:username], params[:password])

      if user = User.where(:name => 'foo').first
        user.update_attributes(:token => token)
      else
        User.create(:name => 'foo', :token => token)
      end

      token
    end

  end
end
