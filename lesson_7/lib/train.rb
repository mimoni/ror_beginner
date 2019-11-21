# Класс Train (Поезд):
# - Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и
#   количество вагонов, эти данные указываются при создании экземпляра класса
# - Может набирать скорость
# - Может возвращать текущую скорость
# - Может тормозить (сбрасывать скорость до нуля)
# - Может возвращать количество вагонов
# - Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
#   метод просто увеличивает или уменьшает количество вагонов).
#   Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# - Может принимать маршрут следования (объект класса Route).
# - При назначении маршрута поезду, поезд автоматически помещается на первую
#   станцию в маршруте.
# - Может перемещаться между станциями, указанными в маршруте.
#   Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# - Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
class Train
  include Validate
  include Manufacturer
  include InstanceCounter
  attr_reader :speed, :wagons, :number, :type

  NUMBER_FORMAT = /^[0-9a-z]{3}-?[0-9a-z]{2}$/i
  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @wagons = []
    @speed = 0
    @type = type
    @@trains[number] = self
    register_instance
    validate!
  end

  def type
    self.class
  end

  def increase_speed(speed = 10)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    @wagons << wagon if @speed.zero? && wagon.type == @type
  end

  def detach_wagon
    raise 'Нельзя отцеплять вагоны на ходу' unless @speed.zero?
    raise 'Вагонов уже нет' unless @wagons.any?
    @wagons.pop
  end

  def assign_route(route)
    @route = route
    @current_index = 0
    route.stations.first.arrival self
  end

  def previous_station
    get_station_by_index @current_index - 1
  end

  def current_station
    get_station_by_index @current_index
  end

  def next_station
    get_station_by_index @current_index + 1
  end

  def move_to_next_station
    return unless @route.stations.size - 1 > @current_index

    current_station.departure self
    next_station.arrival self
    @current_index += 1
  end

  def move_to_previous_station
    return if @current_index.zero?

    current_station.departure self
    previous_station.arrival self
    @current_index -= 1
  end

  def each_wagon
    @wagons.each { |wagon| yield(wagon) } if block_given?
  end

  protected

  def get_station_by_index(index)
    return nil if index < 0

    @route.stations[index]
  end

  def validate!
    raise 'Номер имеет неправельный формат!' unless @number =~ NUMBER_FORMAT
  end
end
