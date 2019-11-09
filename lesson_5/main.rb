require_relative 'lib/manufacturer'
require_relative 'lib/instance_counter'
require_relative 'lib/train'
require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/wagon'
require_relative 'lib/passenger_train'
require_relative 'lib/passenger_wagon'
require_relative 'lib/cargo_train'
require_relative 'lib/cargo_wagon'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def run
    loop do
      clear
      show_main_menu

      case gets.chomp
      when '1' then create_station
      when '2' then create_trains
      when '3' then manage_route
      when '4' then assign_route
      when '5' then attach_wagon_to_train
      when '6' then detach_wagon_of_train
      when '7' then move_train
      when '8' then show_stations_with_train
      when 'exit' then break
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
    puts "\nexit для выхода"
  end

  def show_stations
    puts 'Список станций:'
    @stations.each_with_index do |station, index|
      puts "[#{index}] - #{station}"
    end
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each_with_index do |train, index|
      puts "[#{index}] номер поезда:#{train.number} кол-во вагонов:#{train.wagons.size}"
    end
  end

  def show_routes
    puts "\nСписок маршруов:"
    @routes.each_with_index do |route, index|
      puts "[#{index}] - #{route} кол-во станций:#{route.stations.size}"
    end
  end

  def get_type_train
    puts 'Типы поездов:'
    puts '[1] - Пассажирский поезд'
    puts '[2] - Грузовой поезд'
    puts 'Введите exit для выхода'
    user_input 'Выберите тип поезда', true
  end

  def press_to_continue
    puts "\nНажмите enter, чтобы продолжить"
    gets
  end

  def user_input(message, integer = false)
    print "#{message}: "
    input = gets.chomp
    return nil if input == 'exit'
    integer ? input.to_i : input
  end

  def get_wagon_by_type_train(train)
    wagon = CargoWagon if train.instance_of? CargoTrain
    wagon = PassengerWagon if train.instance_of? PassengerTrain
    wagon
  end

  def create_station
    clear
    puts 'Содание станций:'
    puts 'Введите exit для выхода'
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
      train_type = get_type_train
      break if train_type.nil?
      train_number = user_input 'Введите номер поезда'
      if train_type == 1
        @trains << PassengerTrain.new(train_number)
        puts "Пассажирский поезд с номером #{train_number} создан"
      elsif train_type == 2
        @trains << CargoTrain.new(train_number)
        puts "Грузовой поезд с номером #{train_number} создан"
      else
        puts 'Неверно указан тип поезда!!!'
      end
      press_to_continue
    end
  end

  def manage_route
    clear
    puts 'Создание маршрутов и управление станциями в нем'

    if @stations.size < 2
      puts 'Необходимо создать минимум 2 странции!!!'
      press_to_continue
      return
    end

    loop do
      show_routes
      puts 'exit - для выхода'
      puts 'Введите имя маршрута для его изменения или 10 - для создания нового маршрута,'
      action = user_input '', true
      break if action.nil?

      route = @routes[action]
      if route
        puts "Выбран маршрут: #{route}"
        puts '[1] - для добавлении станции в маршрут'
        puts '[2] - для удаления станции из маршрута'
        puts 'exit - для выхода'
        route_action = user_input '', true
        break if route_action.nil?

        case route_action
        when 1 then
          add_station_to_route route
        when 2 then
          delete_station_from_route route
        end
      elsif action == 10
        create_new_route
      else
        puts "#{action} - такой станции не существует"
        press_to_continue
      end
    end
  end

  def assign_route
    clear
    puts 'Назначать маршрут поезду:'
    show_trains
    number_train = user_input 'Выберите поезд', true
    if @trains[number_train]
      show_routes
      route_index = user_input 'Выберите маршрут', true
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
      train_index = user_input 'Выберите поезд', true
      break if train_index.nil?
      train = @trains[train_index]
      if train
        wagon = get_wagon_by_type_train train
        train.attach_wagon(wagon.new)
        puts "Вакон к поезду #{train} прицеплен"
      else
        puts "Поезд с номером #{train} не существует!!!"
      end
    end
  end

  def detach_wagon_of_train
    clear
    puts 'Отцепить вагоны от поезда'
    loop do
      show_trains
      train_index = user_input 'Выберите поезд', true
      break if train_index.nil?
      train = @trains[train_index]
      if train
        if train.detach_wagon
          puts "От поезда#{train} оцеплен один вагон"
        else
          puts 'Нельзя отцеплять вагоны на ходу или вагонов уже нет!!!'
        end
      else
        puts 'Неправельно указан индекс поезда!!!'
      end
    end
  end

  def move_train
    clear
    puts 'Перемещать поезд по маршруту вперед и назад'
    show_trains
    number_train = user_input 'Выберите поезд', true
    train = @trains[number_train]
    if train
      loop do
        puts "Поезд #{train} находится на станции #{train.current_station}"
        puts "[n] - на следующую станцию #{train.next_station}" if train.next_station
        puts "[p] - на предыдущую станцию #{train.previous_station}" if train.previous_station
        puts 'exit - для выхода'
        action = user_input ''
        break if action.nil?

        case action
        when 'n'
          train.move_to_next_station
          puts "Поезд перемещен на #{train.current_station} станцию"
        when 'p'
          train.move_to_previous_station
          puts "Поезд перемещен на #{train.current_station} станцию"
        else
          puts 'Ошибка ввод!! попробуйте еще раз'
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
    puts 'Список станций'
    @stations.each_with_index do |station, index|
      puts "[#{index}] - Станция #{station}. Кол-во поездов #{station.trains.size}"
    end
    puts 'Веберите станцию чтобы спомотреть список поездов'
    station_index = user_input 'Станция', true
    return if station_index.nil?
    station = @stations[station_index]
    if station
      puts "Список поездов на станции #{station}:"
      station.trains.each { |train| puts "Номер поезда #{train}, тип #{train.type}" }
    else
      puts 'Неправельно указан индекс станции'
    end
    press_to_continue
  end

  def add_station_to_route(route)
    show_stations
    station_index = user_input 'Выберите станцию для добавления', true
    route.add_station @stations[station_index] if @stations[station_index]
  end

  def delete_station_from_route(route)
    puts 'Удаление станций из маршрута:'
    puts 'Список станций:'
    route.show_stations
    station_index = user_input 'Введите индекс станции', true
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
    first_station = @stations[user_input('Введите номер начальной станции', true)]
    last_station = @stations[user_input('Введите номер конечной станции', true)]
    @routes << Route.new(name, first_station, last_station)
    puts "Маршрут #{name} создан."
    press_to_continue
  end
end

Main.new.run
