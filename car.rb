# frozen_string_literal: true

class Car
  attr_reader :number, :type, :capacity
  include Information
  include Validation

  def initialize(number, capacity)
    @number = number
    @capacity = capacity
    validate!
    self.class.all << self
  end

  def self.all
    @@all ||= []
  end

  protected

  def validate!
    raise "Ошибка валидации: номер вагона должен быть текстовым" if @number.class != String
    raise "Ошибка валидации: не указан номер вагона" if @number.empty?
    raise "Ошибка валидации: вместимость должна быть числом" if @capacity.class != Integer
    raise "Количество мест указано некорректно!" if !(1..100).include?(@capacity)
  end

end
