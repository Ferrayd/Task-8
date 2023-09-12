# frozen_string_literal: true

class Station
  attr_reader :name
  include Counter
  include Validation

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    self.class.all << self
  end

  def self.all
    @@all ||= []
  end

  def all_trains
    @trains.each do |train|
      yield(train)  
    end
  end

  def get_train(train)
    @trains << train
    puts "На станцию #{name} прибыл поезд №#{train.number}"
  end

  def send_train(train)
    @trains.delete(train)
    train.station = nil
    puts "Со станции #{name} отправился поезд №#{train.number}"
  end

  protected
  
  def validate!
    raise "Ошибка валидации: название должно быть текстовым" if @name.class != String
    raise "Ошибка валидации: Не указано название станции!" if @name.empty?
  end  

end
