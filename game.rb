class Game
  attr_accessor :periods, :players, :defenders

  def initialize(csv_file)
    require 'csv'

    @defenders = []
    @players   = []

    init_periods

    CSV.foreach(csv_file) do |row|
      player = Player.new(row[0], row[1] || false)

      if player.defender?
        defenders << player
      end

      players << player
    end
  end

  def generate_periods
    init_periods

    8.times do |i|
      periods[i].add_defender get_defender

      4.times do
        periods[i].add_player get_random_player(period)
      end
    end

    print_periods
  end


  def check_defenders
    periods.each do |period|
      if !period.defender
        puts "ERROR:  period #{period.number} does not have a defender."
      end
    end
  end

  def check_player_count_per_period
    success = true

    periods.each do |period|
      players = period.lineup + [period.defender]
      player_names = players.map { |player| player.name }

      if player_names.uniq.count < 5
        puts "ERROR:  period #{period.number} does not have 5 players.  #{player_names}"
        success = false
      elsif player_names.uniq.count > 5
        puts "ERROR:  period #{period.number} has too many players.  #{player_names}"
        success = false
      end
    end

    if success
      puts "Player counts are good.  Nice job."
    else
      puts "See above errors"
    end
  end

  def print_players_per_periods_played
    players.group_by(&:periods_played).each_pair do |periods, players|
      puts "#{periods}"

      players.each do |player|
        puts "  #{player.name}"
      end
      puts
    end
    true
  end

  def print_periods
    periods.sort.each do |period|
      puts "Period #{period.number}:"

      if period.defender
        puts "  #{period.defender.name} - Defense"
      else
        puts "  No defender!"
      end

      period.lineup.each do |player|
        puts "  #{player.name}"
      end
      puts
    end
    puts
  end

  def check_everything
    check_defenders
    check_player_count_per_period
    print_players_per_periods_played
    print_periods
  end

  private

  def init_periods
    @periods = [].tap do |array|
      8.times do |i|
        array << Period.new(i+1)
      end
    end
  end

  # Group the defenders by periods_played.  Then sort them by periods_played.  Then get the first group (lowest played)
  # Then get the values (element [0] is the key) and then randomly take one from that group (`.sample`)
  def get_defender
    get_random_least_played(defenders)
  end

  def get_random_player(period)
    current_players = [lineup.defender] + lineup.players
    get_random_least_played(players)
  end

  def get_random_least_played(player_array)
    player_array.group_by(&:periods_played).sort[0][1].sample
  end
end
