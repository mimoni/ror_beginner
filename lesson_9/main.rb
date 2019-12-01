# frozen_string_literal: true

require_relative 'lib/dependencies'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
    seeds
  end

  def run
    loop do
      clear
      show_main_menu

      begin
        action = user_input
        break if action.nil?

        execute_action action
      rescue StandardError => e
        puts_error e
        press_to_continue
      end
    end
  end

  private

  def clear
    system('clear')
  end

  def show_main_menu
    puts 'Управление станциями и поездами:'
    puts '[1] - Создать станции'
    puts '[2] - Создать поезда'
    puts '[3] - Создать маршруты и управлять станциями в нем'
    puts '[4] - Назначать маршрут поезду'
    puts '[5] - Добавить вагоны к поезду'
    puts '[6] - Отцепить вагоны от поезда'
    puts '[7] - Перемещать поезд по маршруту вперед и назад'
    puts '[8] - Посмотреть список станций и список поездов на станции'
    puts '[9] - Заполнить место или объем в вагоне'
    puts "\nexit для выхода\n"
  end

  def execute_action(action)
    case action
    when '1' then create_station
    when '2' then create_trains
    when '3' then manage_route
    when '4' then assign_route
    when '5' then attach_wagon_to_train
    when '6' then detach_wagon_of_train
    when '7' then move_train
    when '8' then show_stations_with_train
    when '9' then manage_wagon
    end
  end

  def create_station
    clear
    puts 'Содание станций:'
    loop do
      station_name = user_input('Введите имя станции')
      break if station_name.nil?

      @stations << Station.new(station_name)
      puts "Станция с именем #{station_name} создана\n"
    end
  end

  def create_trains
    loop do
      clear
      puts 'Содание поездов:'
      train_type = choice_type_of_train
      break if train_type.nil?

      train_number = user_input('Введите номер поезда')
      make_train(train_type, train_number)
      press_to_continue
    end
  end

  def manage_route
    clear
    puts 'Создание маршрутов и управление станциями в нем'
    raise 'Необходимо создать минимум 2 странции!!!' if @stations.size < 2

    show_routes
    puts 'exit - для выхода'
    puts 'Введите индекс маршрута для его изменения или 10 - для создания нового маршрута,'
    action = user_input('', :int)
    return if action.nil?

    route = @routes[action]
    if route
      manage_stations_in_route(route)
    elsif action == 10
      create_new_route
    else
      puts 'Неправельно указан индес маршрута'
    end
    press_to_continue
  end

  def assign_route
    clear
    puts 'Назначать маршрут поезду:'
    train = choice_train
    show_routes
    route_index = user_input('Выберите маршрут', :int)
    if @routes[route_index]
      train.assign_route(@routes[route_index])
      puts 'Маршрут установлен.'
    end
    press_to_continue
  end

  def attach_wagon_to_train
    clear
    puts 'Добавить вагоны к поезду:'
    train = choice_train

    wagon = get_wagon_by_type_train(train)
    capacity = get_capacity(wagon)
    train.attach_wagon(wagon.new(capacity))
    puts "Вакон к поезду #{train.number} прицеплен"
    press_to_continue
  end

  def detach_wagon_of_train
    clear
    puts 'Отцепить вагоны от поезда'
    train = choice_train
    train.detach_wagon
    puts "От поезда#{train.number} оцеплен один вагон"
    press_to_continue
  end

  def move_train
    clear
    puts 'Перемещать поезд по маршруту вперед и назад'
    train = choice_train

    loop do
      puts "Поезд #{train.number} находится на станции #{train.current_station}"
      puts "[n] - на следующую станцию #{train.next_station}" if train.next_station
      puts "[p] - на предыдущую станцию #{train.previous_station}" if train.previous_station
      puts 'exit - для выхода'
      action = user_input
      break if action.nil?

      case action
      when 'n'
        train.move_to_next_station
        puts "Поезд перемещен на #{train.current_station} станцию"
      when 'p'
        train.move_to_previous_station
        puts "Поезд перемещен на #{train.current_station} станцию"
      else
        puts 'Ошибка ввода!! попробуйте еще раз'
      end

      press_to_continue
      clear
    end
  end

  def show_stations_with_train
    clear
    puts 'Веберите станцию чтобы спомотреть список поездов'
    station = choice_station
    puts "\nСписок поездов на станции #{station}:"
    station.each_train do |train|
      puts "\n #{train}"
      train.each_wagon { |wagon| puts " --- #{wagon}" }
    end
    press_to_continue
  end

  def manage_wagon
    clear
    train = choice_train
    show_wagons(train)
    wagon_index = user_input('Выберите вагон', :int)
    wagon = train.wagons[wagon_index]
    clear
    puts wagon

    if wagon.instance_of?(CargoWagon)
      volume = user_input('Введите объем', :float)
      wagon.load volume
    end

    if wagon.instance_of?(PassengerWagon)
      wagon.take_place
      puts '1 Место в пасажирском вагоне занято'
    end

    puts "\n#{wagon}"
    press_to_continue
  end

  def show_stations
    puts 'Список станций:'
    @stations.each_with_index do |station, index|
      puts "[#{index}] - станция #{station} Кол-во поездов #{station.trains.size}"
    end
  end

  def choice_station
    show_stations
    station_index = user_input('Выберите станцию', :int)

    raise 'Неправельно указан индекс станции' if station_index.nil? || !@stations[station_index]

    @stations[station_index]
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each_with_index do |train, index|
      puts "[#{index}] номер поезда:#{train.number} кол-во вагонов:#{train.wagons.size}"
    end
  end

  def choice_train
    show_trains
    train_index = user_input('Выберите поезд', :int)

    raise 'Неправельно указан индекс поезда' if train_index.nil? || !@trains[train_index]

    @trains[train_index]
  end

  def show_wagons(train)
    train.wagons.each_with_index do |wagon, index|
      puts "[#{index}] номер вагона:#{wagon.name}"
    end
  end

  def show_routes
    puts "\nСписок маршруов:"
    @routes.each_with_index do |route, index|
      puts "[#{index}] - #{route} кол-во станций:#{route.stations.size}"
    end
  end

  def choice_type_of_train
    puts 'Типы поездов:'
    puts '[1] - Пассажирский поезд'
    puts '[2] - Грузовой поезд'
    puts 'Введите exit для выхода'
    user_input('Выберите тип поезда', :int)
  end

  def press_to_continue
    puts "\nНажмите enter, чтобы продолжить"
    gets
  end

  def user_input(message = '', type = :str)
    types = { str: :to_s, int: :to_i, float: :to_f }
    print "#{message}: "
    input = gets.chomp
    return nil if input == 'exit'

    input.send(types[type])
  end

  def get_wagon_by_type_train(train)
    wagon = CargoWagon if train.instance_of? CargoTrain
    wagon = PassengerWagon if train.instance_of? PassengerTrain
    wagon
  end

  def puts_error(error)
    puts "\nОшибка: #{error.message}"
  end

  def make_train(type, number)
    train = build_train(type, number)
    @trains << train
    puts "\n#{train}. создан"
  rescue ValidationError => e
    puts_error e
  end

  def build_train(type, number)
    train_type_map = { 1 => PassengerTrain, 2 => CargoTrain }
    train_klass = train_type_map.fetch(type) { raise 'Неправильно указан тип поезда' }
    train_klass.new(number)
  end

  def manage_stations_in_route(route)
    puts "Выбран маршрут: #{route}"
    puts '[1] - для добавлении станции в маршрут'
    puts '[2] - для удаления станции из маршрута'
    puts 'exit - для выхода'
    route_action = user_input('', :int)

    case route_action
    when 1
      add_station_to_route(route)
    when 2
      delete_station_from_route(route)
    end
  end

  def add_station_to_route(route)
    puts 'Выберите станцию для добавления'
    station = choice_station
    route.add_station(station)
    puts 'Станция добавлена в маршрут'
  end

  def delete_station_from_route(route)
    puts 'Удаление станций из маршрута:'
    puts 'Список станций:'
    route.show_stations
    station_index = user_input('Введите индекс станции', :int)
    return if station_index.nil?

    if route.delete_station(route.stations[station_index])
      puts 'Станция успешно удалена из маршрута'
    else
      puts 'Неправельный индекс'
    end
  end

  def create_new_route
    show_stations
    name = user_input('Введите имя маршрута')
    first_station = @stations[user_input('Введите номер начальной станции', :int)]
    last_station = @stations[user_input('Введите номер конечной станции', :int)]
    @routes << Route.new(name, first_station, last_station)
    puts "Маршрут #{name} создан."
  end

  def get_capacity(wagon)
    if wagon == CargoWagon
      user_input('Введите общий объема вагона (от 50 до 300)', :float)
    elsif wagon == PassengerWagon
      user_input('Введите общее кол-во мест (от 20 до 64)', :int)
    end
  end

  def seeds
    5.times do |i|
      number = i.to_s
      @stations << Station.new(number.rjust(3, '0'))

      if i.even?
        number = number.rjust(6, 'PAS-00')
        train = build_train(1, number)
      else
        number = number.rjust(6, 'CAR-00')
        train = build_train(2, number)
      end

      5.times do
        wagon = get_wagon_by_type_train(train)
        train.attach_wagon(wagon.new)
      end
      @trains << train
    end

    @routes << Route.new('Main', @stations.first, @stations.last)
    @trains.each { |train| train.assign_route @routes.first }
  end
end

Main.new.run
