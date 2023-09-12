# frozen_string_literal: true

class TrainApp

  def initialize
    @routes = []
    @stations = []
  end

  def action
    loop do
      show_actions
      choice = gets.chomp.to_i

      case choice
      when 0
        break
      when 1
        create_station
      when 2
        create_train
      when 3
        create_car
      when 4
        add_wagon_to_train
      when 5
        remove_wagon_from_train
      when 6
        move_train_to_station
      when 7
        list_stations
      when 8
        trains_on_station
      when 9
        list_all_trains
      when 10
        train_car_list
      else
        show_actions_prompt
      end
    end
  end

  private

  def print_text(text)
    puts text
  end

  MENU = ['Выход', 'Создать станцию', 'Создать поезд', 'Создать вагон', 'Прицепить вагон к поезду', 'Отцепить вагон от поезда', 'Поместить поезд на станцию', 'Просмотреть список станций', 'Просмотреть список поездов находящихся на станции', 'Список всех поездов', 'Список вагонов поезда']

  def show_actions
    MENU.each_with_index { |item, index| puts "#{index}. #{item}" }
  end

  def ask(question)
    puts question
    gets.chomp
  end

  def create_station
    name = ask('Введите название станции')
    @stations << Station.new(name)
    print_text("Построена станция #{name}")
  end

  def create_route
    list_stations
    first_station_name = ask('Введите начальную станцию:')
    first_station = @stations.find { |station| station.name = first_station_name }
    last_station_name = ask('Введите конечную станцию:')
    last_station = @stations.find { |station| station.name = last_station_name }
    @routes << Route.new(first_station, last_station)
  end

  def add_station; end

  def create_train
    number = ask('C каким номером?')
    choice = ask('1 - пассажирский, 2 - грузовой').to_i
    case choice
    when 1
      PassengerTrain.new(number)
      print_text("Создан пассажирский поезд №#{number}")
    when 2
      CargoTrain.new(number)
      print_text("Создан грузовой поезд №#{number}")
    else
      print_text('Поезд не создан. Введите 1 или 2')
    end
  end

  def create_car
    number = ask('Введите номер вагона:')
    choice = ask('Выберите тип вагона: 1 - пассажирский, 2 - грузовой').to_i
    capacity = ask('Укажите количество мест/Объем').to_i
    case choice
      when 1
        PassengerCar.new(number, capacity)
      when 2
        CargoCar.new(number, capacity)
    end
    print_text("Создан новый вагон <#{Car.all.last.number}>")
  end

  def add_wagon_to_train
    list_all_trains
    train = Train.all[ask('Добавляем вагон поезду. Выберите поезд:').to_i]

    print_cars
    train.add_car(Car.all[ask('Выберите вагон:').to_i])

    print_text("Изменен состав поезда <#{train.number}>")
  end

  def remove_wagon_from_train
    train = Train.all[ask('Отцепляем вагон от поезда. Выберите поезд:').to_i]
    train.remove_car(train.cars[ask('Выберите вагон:').to_i])

    print_text("Изменен состав поезда <#{train.number}>")
  end

  def choose_station
    list_stations
    name = ask('На какую станцию? (название)')
    @stations.detect { |station| station.name == name }
  end

  def move_train_to_station
    if !Train.all
      print_text('Сначала Сначала создайте поезд')
    elsif @stations.empty?
      print_text('Сначала создайте станцию')
    else
      train = Train.all[ask('Какой поезд?').to_i]
      if train.nil?
        print_text('Поезда с таким номером нет')
      else
        station = choose_station()
        if station.nil?
          print_text('Такой станции нет')
        else
          station.get_train(train)
        end
      end
    end
  end

  def trains_on_station
    station = choose_station()
    print_text("Список поездов на стации <#{station.name}>")
    station.all_trains do |train| 
      print_text("Поезд #{train.number} (тип: #{train.type}) #{"вагонов: #{train.cars.count}"}")
    end
  end

  def train_car_list
    list_all_trains
    train = Train.all[ask("Выберите поезд: ").to_i]
    print_text("Список вагонов поезда <#{train.number}>")   
    train.train_composition do |car| 
      print_text("Вагон № #{car.number} (тип: #{car.type}), загрузка: #{car.reserved} из #{car.capacity}, свободно: #{car.free}")
    end
  end

  def list_all_trains
    print_text('Список поездов:')
    Train.all.each_with_index { |v, i| puts "#{i}. #{v.number}, #{v.type}" }
  end
  def print_cars
    print_text('Список вагонов:')
    Car.all.each_with_index { |v, i| puts "#{i}. #{v.number}, #{v.type}" }
  end

  def list_stations
    print_text('Список станций:')
    @stations.each_with_index { |station| puts station.name }
  end

  def show_actions_prompt
    print_text('Необходимо выбрать один из предложенных вариантов')
  end
end
