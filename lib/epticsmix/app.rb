module EpticsMix
  class App < Sinatra::Base
    enable :sessions

    set :github_options, {
      :secret    => ENV['GH_CLIENT_SECRET'],
      :client_id => ENV['GH_CLIENT_ID'],
    }

    register Sinatra::Auth::Github

    get '/' do
      authenticate!

      <<-HTML
  <html>
    <body>
      <p>Hi there. I'm gonna need your username and password for <a href='http://www.epicmix.com'>/http://www.epicmix.com/</a>, it's probably your
         email address. You did use a random password, right?</p>
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

    get '/vanity' do
      users = User.all.sort_by {|u| u.vertical_feet }.reverse

      rank_by('vertical feet', users, :vertical_feet)
    end

    get '/vanity/points' do
      users = User.all.sort_by {|u| u.points }

      rank_by('epic points', users, :points)
    end

    helpers do
      def github_name
        github_user.name
      end

      def rank_by(type, users, method)
        padding = users.map {|u| u.name.size }.max

        first_place = users.shift
        top_value   = first_place.send(method).to_i

        message = "#{first_place.name.rjust(padding)}: #{top_value.to_s.rjust(10)} #{type}\n"

        users.inject(top_value) do |last_value, user|
          value      = user.send(method).to_i
          difference = last_value - value
          message << "#{user.name.rjust(padding)}: #{value} ( #{difference.to_s.rjust(10)} to go)\n"

          value
        end

        message
      end
    end

  end
end
