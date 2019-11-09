class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :speed, :wagons, :type, :number, :current_station

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def to_s
    @number
  end

  def increase_speed(speed = 10)
    new_speed = @speed + speed
    @speed = new_speed if new_speed.positive?
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    @wagons << wagon if @speed.zero? && wagon.type == @type
  end

  def detach_wagon
    @wagons.pop if @speed.zero? && @wagons.any?
  end

  def set_route(route)
    @route = route
    @current_station = @route.stations.first
  end

  def move_forward
    @current_station = next_station unless @route.stations.last == @current_station
  end

  def move_backward
    @current_station = previous_station unless @route.stations.first == @current_station
  end


  def previous_station
    @route.stations[get_index_station - 1]
  end

  def next_station
    @route.stations[get_index_station + 1]
  end

  protected

  def get_index_station
    @route.stations.index(@current_station)
  end
end
