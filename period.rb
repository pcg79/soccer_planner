class Period
  include Enumerable

  attr_accessor :number, :lineup, :defender

  def initialize(number)
    @number = number
    @lineup = []
  end

  def add_player(player)
    player.increment_played
    @lineup << player
  end

  def add_defender(player)
    player.increment_played
    @defender = player
  end

  def each(&block)
    @lineup.each(&block)
  end

  def <=>(other)
    number <=> other.number
  end
end