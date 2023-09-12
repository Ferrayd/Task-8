# frozen_string_literal: true

class Route
  attr_reader :stations
  include Counter
  include Validation

  def initialize(from, to)
    @stations = [from, to]
    validate!
    register_instance
    @title = name
    self.class.all << self
  end

  def self.all
    @@all ||= []
  end

  def add_station(station)
    stations.insert(-2, station)
    puts "К маршруту #{name} добавлена станция #{station.name}"
  end

  def remove_station(station)
    if [stations.first, stations.last].include?(station)
      puts 'Первую и последнюю станции маршрута удалять нельзя!'
    else
      stations.delete(station)
      puts "Из маршрута #{name} удалена станция #{station.name}"
    end
  end

  def show_stations
    puts "В маршрут #{name} входят станции: "
    stations.each { |station| puts " #{station.name}" }
  end

  def name
    "#{stations.first.name} - #{stations.last.name}"
  end

  def validate!
    @stations.each_with_index do |v, i|
      raise "Ошибка валидации: параметр #{i+1} (ожидается тип Station)" if v.class != Station
    end
  end
end
