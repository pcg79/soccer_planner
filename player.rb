class Player
  attr_accessor :name, :defense, :periods_played

  alias_method :defense?, :defense

  def initialize(name, defense=false)
    @name = name
    @defense = defense
    @periods_played = 0
  end
end
