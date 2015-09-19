class Game
  attr_accessor :lineups, :players, :defenders

  def initialize(lineups)
    @lineups = lineups
  end

  def initialize(csv_file)
    CSV.foreach(csv_file) do |row|
      players << Player.new(row[0], row[1] || false)
    end
  end

  def check_defenders
    success = true

    lineups.keys.each do |key|
      players = lineups[key]

      defenders = players.select { |player| player.defense? }

      if defenders.count > 1
        puts "ERROR:  period #{key} has more than one defender.  #{defenders.map { |p| p.name }}"
        success = false
      elsif defenders.count < 1
        puts "ERROR:  period #{key} does not have a defender."
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
    lineups.keys.each do |key|
      players = lineups[key]

      player_names = players.map { |player| player.name }
      if player_names.uniq.count < 5
        puts "ERROR:  period #{key} does not have 5 players.  #{player_names}"
        success = false
      elsif player_names.uniq.count > 5
        puts "ERROR:  period #{key} has too many players.  #{player_names}"
        success = false
      end
    end

    if success
      puts "Player counts are good.  Nice job."
    else
      puts "See above errors"
    end
  end

  def print_players_per_period
    {}.tap { |hash| lineups.values.flatten.each { |player| hash[player.name] ||= 0; hash[player.name] += 1 } }
  end

  def check_everything
    check_defenders
    check_player_count_per_period
    print_players_per_period
  end
end
