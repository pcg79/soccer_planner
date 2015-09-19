oneA = %w(
EthanD
Armani
Aaron
Tyler
Evan
)

oneB = %w(
JohnPaul
Aldrin
JohnnyD
Joshua
Ethan
)

twoA = %w(
Armani
Aaron
Tyler
Evan
JohnPaulD
)

twoB = %w(
Aldrin
Johnny
Joshua
Ethan
ArmaniD
)

threeA = %w(
AaronD
Tyler
Evan
JohnPaul
Aldrin
)

threeB = %w(
JohnnyD
Joshua
Ethan
Armani
Aaron
)

fourA = %w(
Tyler
Evan
JohnPaul
AldrinD
Johnny
)

fourB = %w(
Joshua
Ethan
Armani
Aaron
TylerD
)



game_array = [ oneA, oneB, twoA, twoB, threeA, threeB, fourA, fourB ]

period_num = 0

lineups = {}.tap do |hash|
  game_array.map do |period|
    period_num += 1


    players = period.map do |name|
      if name =~ /(.*)D$/
        Player.new $1, true
      else
        Player.new name
      end
    end

    hash[period_num] = players
  end
end


ogame.keys.each do |key|
  players = ogame[key]

  player_names = players.map { |player| player.name }
  if player_names.uniq.count < 5
    puts "ERROR:  period #{key} does not have 5 players.  #{player_names}"
  end

  defenders = players.select { |player| player.defense? }

  if defenders.count > 1
    puts "ERROR:  period #{key} has more than one defender.  #{defenders.map { |p| p.name }}"
  end
end

{}.tap { |hash| ogame.values.flatten.each { |player| hash[player.name] ||= 0; hash[player.name] += 1 } }