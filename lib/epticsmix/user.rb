module EpticsMix
  class User < ActiveRecord::Base

    def client
      @client ||= Client.new(self.username, self.password)
    end

    def season_stats(year = 2012)
      @season_stats ||= begin
        stats = client.season_stats
        return {} if stats.nil?

        stats.detect {|season| season['year'] == year.to_i } || {}
      end
    end

    def vertical_feet
      @vertical_feet ||= season_stats['verticalFeet'] || 0
    end

    def points
      @points ||= season_stats['points'] || 0
    end

  end
end
