class PassengerCar < Car
  def initialize(number, capacity)
    super
    @seats  = Hash[(1..capacity).zip(Array.new(capacity, false))]
    @type = :passenger
  end
  def book(seat_num)
    @seats[seat_num] = true if seat_num <= @capacity
  end

  def reserved
    @seats.select { |key, value| value }.keys.size
  end

  def free
    @seats.select { |key, value| !value }.keys.size
  end
end