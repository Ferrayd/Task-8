class CargoCar < Car
  def initialize(number, capacity)
    super
    @type = :cargo
    @load = 0
  end
   
  def fill(value)
    @load += value if @load + value <= @capacity
  end

  def reserved
    @load
  end

  def free
    @capacity-@load
  end
end