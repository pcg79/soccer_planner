class Game
  attr_accessor :lineups, :players, :defenders

  def initialize(csv_file)
    require 'csv'

    @defenders = []
    @players   = []

    init_lineups

    CSV.foreach(csv_file) do |row|
      player = Player.new(row[0], row[1] || false)

      if player.defender?
        defenders << player
      end

      players << player
    end
  end

  def generate_lineups
    8.times do |period|
      defender = get_defender

      lineups[period].add_player defender

      4.times do
        lineups[period].add_player get_random_player
      end
    end
  end


  def check_defenders
    success = true

    lineups.each do |period|
      players = period.lineup
      defenders = players.select { |player| player.defense? }

      if defenders.count > 1
        puts "ERROR:  period #{period.number} has more than one defender.  #{defenders.map { |p| p.name }}"
        success = false
      elsif defenders.count < 1
        puts "ERROR:  period #{period.number} does not have a defender."
        success = false
      end
    end

    if success
      puts "Defenders are good.  Nice job."
    else
      puts "See above errors"
    end
  end

  def check_player_count_per_period
    success = true

    lineups.each do |period|
      players = period.lineup
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

  def check_everything
    check_defenders
    check_player_count_per_period
    print_players_per_period
  end

  private

  def init_lineups
    @lineups = [].tap do |array|
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

  def get_random_player
    get_random_least_played(players)
  end

  def get_random_least_played(player_array)
    player_array.group_by(&:periods_played).sort[0][1].sample
  end
end
