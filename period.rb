class Period
  include Enumerable

  attr_accessor :number, :lineup

  def initialize(number)
    @number = number
    @lineup = []
  end

  def add_player(player)
    player.increment_played
    @lineup << player
  end

  def each(&block)
    @lineup.each(&block)
  end
end