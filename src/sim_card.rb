class SimCard
  attr_accessor :code, :name, :price, :free

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  # minitest's assert_equal would fail without this method
  # ref: https://makandracards.com/david-alejandro/44636-minitest-testing-equality
  def ==(other_sim)
    other_sim.is_a?(SimCard) and
    code == other_sim.code and
    name == other_sim.name and
    price == other_sim.price
  end
end
