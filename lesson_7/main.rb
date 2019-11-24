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
    puts "[9] - Заполнить место или объем в вагоне\nexit для выхода\n"
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

  def show_stations
    puts 'Список станций:'
    @stations.each_with_index do |station, index|
      puts "[#{index}] - станция #{station} Кол-во поездов #{station.trains.size}"
    end
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each_with_index do |train, index|
      puts "[#{index}] номер поезда:#{train.number} кол-во вагонов:#{train.wagons.size}"
    end
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
    puts 'exit - для выхода'
    puts 'Введите имя маршрута для его изменения или 10 - для создания нового маршрута,'
  end

  def receive_type_train
    puts 'Типы поездов:'
    puts '[1] - Пассажирский поезд'
    puts '[2] - Грузовой поезд'
    puts 'Введите exit для выхода'
    user_input 'Выберите тип поезда', Integer
  end

  def press_to_continue
    puts "\nНажмите enter, чтобы продолжить"
    gets
  end

  def user_input(message = '', type = String)
    print "#{message}: "
    input = gets.chomp

    return nil if input == 'exit'

    if type == Integer
      input.to_i
    elsif type == Float
      input.to_f
    else
      input
    end
  end

  def get_wagon_by_type_train(train)
    wagon = CargoWagon if train.instance_of? CargoTrain
    wagon = PassengerWagon if train.instance_of? PassengerTrain
    wagon
  end

  def puts_error(error)
    puts "\nОшибка: #{error.message}"
  end

  def create_station
    clear
    puts 'Содание станций:'
    loop do
      station_name = user_input 'Введите имя станции'
      break if station_name.nil?

      @stations << Station.new(station_name)
      puts "Станция с именем #{station_name} создана\n"
    end
  end

  def create_trains
    loop do
      clear
      puts 'Содание поездов:'
      train_type = receive_type_train
      break if train_type.nil?

      train_number = user_input 'Введите номер поезда'
      make_train(train_type, train_number)
      press_to_continue
    end
  end

  def make_train(type, number)
    train = build_train(type, number)
    @trains << train
    puts "\n#{train}. создан"
  rescue StandardError => e
    puts_error e
  end

  def build_train(type, number)
    train_type_map = { 1 => PassengerTrain, 2 => CargoTrain }
    train_klass = train_type_map.fetch(type) { raise 'Неправильно указан тип поезда' }
    train_klass.new(number)
  end

  def show_route_menu(route)
    puts "Выбран маршрут: #{route}"
    puts '[1] - для добавлении станции в маршрут'
    puts '[2] - для удаления станции из маршрута'
    puts 'exit - для выхода'
  end

  def manage_route
    clear
    puts 'Создание маршрутов и управление станциями в нем'

    raise 'Необходимо создать минимум 2 странции!!!' if @stations.size < 2

    loop do
      show_routes
      action = user_input '', Integer
      break if action.nil?

      route = @routes[action]
      if route
        show_route_menu(route)
        route_action = user_input '', Integer
        break if route_action.nil?

        case route_action
        when 1
          add_station_to_route route
        when 2
          delete_station_from_route route
        end
      elsif action == 10
        create_new_route
      else
        puts 'Неправельно указан индес маршрута'
        press_to_continue
      end
    end
  end

  def assign_route
    puts 'Назначать маршрут поезду:'
    show_trains
    number_train = user_input 'Выберите поезд', Integer
    if @trains[number_train]
      show_routes
      route_index = user_input 'Выберите маршрут', Integer
      if @routes[route_index]
        @trains[number_train].assign_route @routes[route_index]
        puts 'Маршрут установлен.'
      end
    else
      puts "Поезд с номером #{number_train} не существует!!!"
    end
    press_to_continue
  end

  def attach_wagon_to_train
    clear
    puts 'Добавить вагоны к поезду:'
    loop do
      show_trains
      train_index = user_input 'Выберите поезд', Integer
      break if train_index.nil?

      train = @trains[train_index]
      if train
        wagon = get_wagon_by_type_train(train)
        capacity = get_capacity(wagon)
        train.attach_wagon(wagon.new(capacity))
        puts "Вакон к поезду #{train.number} прицеплен"
      else
        puts "Поезд с номером #{train.number} не существует!!!"
      end
    end
  end

  def detach_wagon_of_train
    clear
    puts 'Отцепить вагоны от поезда'
    loop do
      show_trains
      train_index = user_input 'Выберите поезд', Integer
      break if train_index.nil?

      train = @trains[train_index]
      if train
        detach_wagon train
      else
        puts 'Неправельно указан индекс поезда!!!'
      end
    end
  end

  def detach_wagon(train)
    train.detach_wagon
    puts "От поезда#{train.number} оцеплен один вагон"
  rescue StandardError => e
    puts_error e
  end

  def show_choice_menu_train(train)
    puts "Поезд #{train.number} находится на станции #{train.current_station}"
    puts "[n] - на следующую станцию #{train.next_station}" if train.next_station
    puts "[p] - на предыдущую станцию #{train.previous_station}" if train.previous_station
    puts 'exit - для выхода'
  end

  def move_train
    clear
    puts 'Перемещать поезд по маршруту вперед и назад'
    show_trains
    number_train = user_input 'Выберите поезд', Integer
    return if number_train.nil?

    train = @trains[number_train]
    if train
      loop do
        show_choice_menu_train(train)
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
    else
      puts "Поезда с номером #{number_train} не существует"
      press_to_continue
    end
  end

  def show_stations_with_train
    clear
    show_stations
    puts 'Веберите станцию чтобы спомотреть список поездов'
    station_index = user_input 'Станция', Integer
    return if station_index.nil?

    station = @stations[station_index]
    if station
      clear
      puts "Список поездов на станции #{station}:"
      station.each_train do |train|
        puts "\n #{train}"
        train.each_wagon { |wagon| puts " --- #{wagon}" }
      end
    else
      puts 'Неправельно указан индекс станции'
    end
    press_to_continue
  end

  def add_station_to_route(route)
    show_stations
    station_index = user_input 'Выберите станцию для добавления', Integer
    route.add_station @stations[station_index] if @stations[station_index]
  end

  def delete_station_from_route(route)
    puts "Удаление станций из маршрута: \nСписок станций:\n"
    route.show_stations
    station_index = user_input 'Введите индекс станции', Integer
    return if station_index.nil?

    if route.delete_station(route.stations[station_index])
      puts 'Станция успешно удалена из маршрута'
    else
      puts 'Неправельный индекс'
    end
    press_to_continue
  end

  def create_new_route
    show_stations
    name = user_input 'Введите имя маршрута'
    first_station = @stations[user_input('Введите номер начальной станции', Integer)]
    last_station = @stations[user_input('Введите номер конечной станции', Integer)]
    @routes << Route.new(name, first_station, last_station)
    puts "Маршрут #{name} создан."
    press_to_continue
  end

  def get_capacity(wagon)
    if wagon == CargoWagon
      user_input 'Введите общий объема вагона (от 50 до 300)', Float
    elsif wagon == PassengerWagon
      user_input 'Введите общее кол-во мест (от 20 до 64)', Integer
    end
  end

  def manage_wagon
    clear
    show_trains
    train_number = user_input 'Веберите поезд', Integer
    train = @trains[train_number]
    raise 'Неправельно указан номер поезда' unless train

    show_wagons train
    wagon_index = user_input 'Выберите вагон', Integer
    wagon = train.wagons[wagon_index]
    clear
    puts wagon

    if wagon.instance_of?(CargoWagon)
      volume = user_input 'Введите объем', Float
      wagon.take_space(volume)
    end

    if wagon.instance_of?(PassengerWagon)
      wagon.take_space
      puts '1 Место в пасажирском вагоне занято'
    end

    puts "\n#{wagon}"
    press_to_continue
  end

  def seeds
    5.times do |i|
      name = i.to_s
      @stations << Station.new(name.rjust(3, '0'))

      train = if i.even?
                build_train(1, name.rjust(6, 'PAS-00'))
              else
                build_train(2, name.rjust(6, 'CAR-00'))
              end

      5.times do
        train.attach_wagon(get_wagon_by_type_train(train).new)
      end

      @trains << train
    end

    @routes << Route.new('Main', @stations.first, @stations.last)
    @trains.each { |train| train.assign_route @routes.first }
  end
end

Main.new.run
