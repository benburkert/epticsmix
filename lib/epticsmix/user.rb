module EpticsMix
  class User < ActiveRecord::Base

    def client
      @client ||= Client.new(self.username, self.password)
    end

    def season_stats(year = 2011)
      client.season_stats.detect {|season| season['year'] == year.to_i }
    end

    def vertical_feet
      @vertical_feet ||= season_stats['verticalFeet']
    end

    def points
      @points ||= season_stats['points']
    end

  end
end
