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
      if user = User.where(:name => github_name).first
        user.update_attributes(:username => params[:username], :password => params[:password])
      elsif user = User.where(:username => params[:username]).first
        user.update_attributes(:name => github_name, :password => params[:password])
      else
        user = User.create(:name => github_name, :username => params[:username], :password => params[:password])
      end

      if user.valid?
        redirect to('/vanity')
      else
        redirect to('/')
      end
    end

    get '/vanity(/feet)' do
      users = User.all.sort_by {|u| u.vertical_feet }

      User.all.map {|u| "#{u.name}: #{u.vertical_feet}" }.join("\n")
    end

    get '/vanity/points' do
      users = User.all.sort_by {|u| u.points }
      User.all.map {|u| "#{u.name}: #{u.points}" }.join("\n")
    end

    helpers do
      def github_name
        github_user.name
      end
    end

  end
end
