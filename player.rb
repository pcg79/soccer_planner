class Player
  attr_accessor :name, :defense, :periods_played

  alias_method :defense?, :defense
  alias_method :defender?, :defense

  def initialize(name, defense=false)
    @name = name
    @defense = defense
    @periods_played = 0
  end

  def increment_played
    @periods_played += 1
  end

  def reset_played
    @periods_played = 0
  end
end
