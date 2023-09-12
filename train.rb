# frozen_string_literal: true

class Train
  attr_reader :number, :cars, :type, :speed, :route, :station
  include Counter
  include Information
  include Validation

  NUM_FORMAT = /^\w{3}-?\w{2}$/i

  def initialize(number)
    @number = number
    @speed = 0
    @cars = []
    validate!
    register_instance
    self.class.all << self
  end

  def self.all
    @@all ||= []
  end

  def train_composition
    @cars.each do |composition|
      yield(composition)  
    end
  end

  def self.find(number)
    result = all.select { |train| train if train.number == number }
    result.empty? ? nil : result.first
  end

  def stop
    self.speed = 0
  end

  def add_car(car)
    @cars << car if !@cars.member?(car) && car.type == self.type
  end

  def remove_car(car)
    @cars.delete(car) if car.type == self.type
  end

  def take_route(route)
    self.route = route
    puts "Поезду №#{number} задан маршрут #{route.name}"
  end

  def go_to(station)
    if route.nil?
      puts 'Без маршрута поезд заблудится.'
    elsif @station == station
      puts "Поезд №#{@number} и так на станции #{@station.name}"
    elsif route.stations.include?(station)
      @station&.send_train(self)
      @station = station
      station.get_train(self)
    else
      puts "Станция #{station.name} не входит в маршрут поезда №#{number}"
    end
  end

  def stations_around
    if route.nil?
      puts 'Маршрут не задан'
    else
      station_index = route.stations.index(station)
      puts "Сейчас поезд на станции #{station.name}."
      puts "Предыдущая станция - #{route.stations[station_index - 1].name}." if station_index != 0
      puts "Следующая - #{route.stations[station_index + 1].name}." if station_index != route.stations.size - 1
    end
  end
  protected

  def validate!
    raise ArgumentError, "Ошибка валидации: номер позеда должен иметь строковый тип" if number.class != String
    raise ArgumentError, "Ошибка валидации: ожидается формат XXX-XX или XXXXX" if number !~ NUM_FORMAT
  end

end
