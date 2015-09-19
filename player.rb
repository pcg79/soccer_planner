class Player
  attr_accessor :name, :defense

  alias_method :defense?, :defense

  def initialize(name, defense=false)
    @name = name
    @defense = defense
  end
end
